#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <pthread.h>
#include <assert.h>
#include "common.h"
#include "ll.h"
#include "kv.h"
#include "hash.h"

/* Spinlock para LRU? */
#define SPIN 0

/* Spinlocks para los bins? */
#define SPIN_BIN 0

struct bin {
	/* Una lista de struct kv, sin orden en particular */
	struct list vals;
};

static int TableSZ;
static struct bin *Table;
static struct list LRU = LIST_INIT(LRU);

static int LocksPow;
static int LocksSZ;   /* == 1<<LocksPow */
static int LocksMask; /* == LocksSz - 1 */

#if SPIN_BIN
static pthread_spinlock_t *Locks;
#else
static pthread_mutex_t *Locks;
#endif

#if SPIN
pthread_spinlock_t LRU_lk;
#else
pthread_mutex_t LRU_lk;
#endif

void lru_lock()
{
#if SPIN
	pthread_spin_lock(&LRU_lk);
#else
	pthread_mutex_lock(&LRU_lk);
#endif
}

void lru_unlock()
{
#if SPIN
	pthread_spin_unlock(&LRU_lk);
#else
	pthread_mutex_unlock(&LRU_lk);
#endif
}

void lru_init()
{
#if SPIN
	pthread_spin_init(&LRU_lk, PTHREAD_PROCESS_PRIVATE);
#else
	pthread_mutex_init(&LRU_lk, NULL);
#endif
}

static void bin_lockinit(int idx)
{
#if SPIN_BIN
	pthread_spin_init(&Locks[idx], 0);
#else
	pthread_mutex_init(&Locks[idx], NULL);
#endif
}

static void bin_lock(int idx)
{
#if SPIN_BIN
	pthread_spin_lock(&Locks[idx & LocksMask]);
#else
	pthread_mutex_lock(&Locks[idx & LocksMask]);
#endif
}

static int bin_trylock(int idx)
{
#if SPIN_BIN
	return pthread_spin_trylock(&Locks[idx & LocksMask]);
#else
	return pthread_mutex_trylock(&Locks[idx & LocksMask]);
#endif
}

static void bin_unlock(int idx)
{
#if SPIN_BIN
	pthread_spin_unlock(&Locks[idx & LocksMask]);
#else
	pthread_mutex_unlock(&Locks[idx & LocksMask]);
#endif
}


long kv_keys()
{
	long r = 0;
	int i;
	/* Recorremos todos los bins contando cuantos pares KV tenemos */

	for (i = 0; i < TableSZ; i++) {
		struct list *p;
		bin_lock(i);
		list_for_each(p, &Table[i].vals)
			r++;
		bin_unlock(i);
	}


	return r;
}

static int binof(u64 hash)
{
	return hash % TableSZ;
}

/* Refcounting */
static void kv_free(struct kv *kv)
{
	/* El nodo YA DEBE estar deslinkeado de ambas listas */
	assert(kv->lru.next == NULL);
	assert(kv->lru.prev == NULL);
	assert(kv->list.next == NULL);
	assert(kv->list.prev == NULL);

	/* log(0, "free"); */
	free(kv->v);
	free(kv->k);
	free(kv);
}


static inline void kv_grab(struct kv *kv)
{
	kv->nrefs++;
}


void __kv_release(struct kv *kv)
{
	assert (kv->nrefs > 0);
	kv->nrefs--;
	if (kv->nrefs == 0) {
		/*
		 * Si nrefs == 0, no puede estar en la tabla
		 * ni LRU, así que es seguro liberarlo.
		 */
		kv_free(kv);
	}
}

void kv_release(struct kv *kv)
{
	int bin = kv->bin;
	bin_lock(bin);
	__kv_release(kv);
	bin_unlock(bin);

}
/* / Refcounting */

/* Retorna una cota inferior de los bytes liberados */
static int kv_evict1()
{
	struct list *p;
	struct kv *kv;
	int bin;

	/*
	 * Nota: hacemos trylock dentro del bucle para evitar
	 * un posible deadlock, ya que hay un ciclo en el
	 * orden de los recursos.
	 */

	log(2, "EVICT1 comenzando");

	lru_lock();
	for (p = LRU.prev; p != &LRU; p = p->prev) {
		kv = list_entry(p, struct kv, lru);
		bin = kv->bin;

		/* Intentar tomar lock, si falla seguimos */
		if (bin_trylock(bin) != 0)
			continue;

		/*
		 * Si está tomado por alguien (aparte de la misma
		 * tabla), lo ignoramos
		 */
		if (kv->nrefs > 1) {
			bin_unlock(bin);
			continue;
		}

		/* Si no, listo, liberamos este. Salimos con lock tomado */
		break;
	}

	/* Si entramos acá, no encontramos nada, y no tenemos ningún lock. */
	if (p == &LRU) {
		log(1, "LRU vacía!?!?");
		lru_unlock();
		return 0;
	}

	int r = kv->klen + kv->vlen;

	/* Lo sacamos de la LRU y del mapa, y soltamos la ref de la tabla. */
	list_unlink(&kv->lru);
	list_unlink(&kv->list);
	__kv_release(kv);

	bin_unlock(bin);
	lru_unlock();

	return r;
}

void * galloc(size_t size)
{
	void * ret;
	int laps = 0;

	ret = malloc(size);
	while (!ret && laps < 10) {
		kv_evict1();
		ret = malloc(size);
		laps++;
	}

	if (!ret)
		log(2, "galloc no anduvo!!");

	return ret;
}

void * memdup(const void *p, int len)
{
	void *r = galloc(len);
	if (!r) {
		log(2, "memdup OOM");
		return NULL;
	}
	memcpy(r, p, len);
	return r;
}

static bool kmatch(int klen1, const char *k1, int klen2, const char *k2)
{
	if (klen1 != klen2)
		return false;

	return (memcmp(k1, k2, klen1) == 0);
}

struct kv * __kv_lookup(u64 hash, int idx, int klen, const char *k)
{
	struct list *p;

	list_for_each(p, &Table[idx].vals) {
		struct kv *kv = list_entry(p, struct kv, list);
		/* log(2, "loop k = %s", kv->k); */
		if (hash != kv->hash)
			continue;

		if (kmatch(klen, k, kv->klen, kv->k))
			return kv;
	}

	return NULL;
}


static void bump(struct kv *kv)
{
	assert(kv);
	struct list *l = &kv->lru;

	lru_lock();
	assert(l->next);
	assert(l->prev);
	list_unlink(l);
	list_add_head(&LRU, l);
	lru_unlock();

}

struct kv * kv_lookup(int klen, const char *k)
{
	u64 hash = hash_buf(klen, k);
	int idx = binof(hash);


	bin_lock(idx);
	struct kv * ret = __kv_lookup(hash, idx, klen, k);
	if (ret) {
		kv_grab(ret);
		bump(ret);
	}
	bin_unlock(idx);

	return ret;
}

/* devuelve .list y .lru sin inicializar */
static
struct kv * new_node(u64 hash, int idx, int klen, char *k, int vlen,
		     char *v)
{
	/* No estaba, crear e insertar */
	struct kv *node = galloc(sizeof *node);
	if (!node)
		return NULL;

	node->hash   = hash;
	node->bin    = idx;
	node->klen   = klen;
	node->k      = k;
	node->vlen   = vlen;
	node->v      = v;
	node->nrefs  = 0;

	return node;
}

int kv_add(int klen, char *k, int vlen, char *v)
{
	assert(k);
	assert(v);
	u64 hash = hash_buf(klen, k);
	int idx = binof(hash);

	/*
	 * Siempre creamos un nodo nuevo, borramos el nodo existente si
	 * lo había, y luego insertamos.
	 *
	 * Por qué esta lógica? Es más facil por el conteo de referencias...
	 * porque para cambiarle el valor al nodo actual, tendríamos que
	 * sobreescribir kv->v, y liberar el viejo, pero el mismo puede estar
	 * siendo usado. En vez de agregar *otro* conteo de referencias para
	 * kv->v, simplemente hacemos un nodo KV nuevo.
	 */

	struct kv *new = new_node(hash, idx, klen, k, vlen, v);
	if (!new) {
		log(2, "kv_add oom");
		return -1;
	}
	kv_grab(new);

	bin_lock(idx);

	struct kv *old = __kv_lookup(hash, idx, klen, k);

	lru_lock();

	/* Si existía algo en esta clave, lo removemos. */
	if (old) {
		list_unlink(&old->list);
		list_unlink(&old->lru);
		__kv_release(old);
	}

	/*
	 * Agregamos el nodo a *ambas* listas atómicamente, bajo ambos
	 * locks.
	 */
	list_add_head(&Table[idx].vals, &new->list);
	list_add_head(&LRU, &new->lru);
	lru_unlock();

	bin_unlock(idx);

	return 0;
}


/*
 * No hay free! Sólo saca el elemento del mapa. El llamante
 * debe usar eventualmente kv_release para borrarlo.
 */
struct kv * kv_take(int klen, const char *k)
{
	u64 hash = hash_buf(klen, k);
	int idx = binof(hash);
	bin_lock(idx);
	struct kv * ret = __kv_lookup(hash, idx, klen, k);
	if (ret) {
		/* Quitar de la tabla */
		lru_lock();
		list_unlink(&ret->list);
		list_unlink(&ret->lru);
		lru_unlock();
		/*
		 * Nota: no tocamos el refcount. Canjeamos la referencia
		 * desde la tabla por la referencia desde el código cliente,
		 * quedando el refcount igual.
		 */
	}
	bin_unlock(idx);
	return ret;
}
bool kv_remove(int klen, const char *k)
{
	/* Quitar y soltar, nada más */
	struct kv *kv = kv_take(klen, k);
	if (kv) {
		kv_release(kv);
		return true;
	} else {
		return false;
	}
}

void kv_clear_all()
{
	struct list *p, *swap;
	int i;

	log(3, "CLEAR ALL");

	for (i = 0; i < TableSZ; i++) {
		bin_lock(i);
		lru_lock();
		list_for_each_safe(p, swap, &Table[i].vals) {
			struct kv *kv = list_entry(p, struct kv, list);
			list_unlink(&kv->list);
			list_unlink(&kv->lru);
			__kv_release(kv);
		}
		lru_unlock();
		bin_unlock(i);
	}
}

int kv_init(int tablesz)
{
	int i;

	TableSZ = tablesz;
	Table = malloc(TableSZ * sizeof Table[0]);
	if (!Table)
		quit("malloc kv_init");

	for (i = 0; i < TableSZ; i++)
		list_init(&Table[i].vals);


	/*INICIALIZAR LOCKS*/
	
	LocksPow  = 6; /* 64 locks */
	LocksSZ   = 1 << LocksPow;
	LocksMask = LocksPow - 1;
	Locks = malloc(LocksSZ * sizeof Locks[0]);
	if (!Locks)
		quit("kv_init malloc locks");

	for (i = 0; i < LocksSZ; i++)
		bin_lockinit(i);

	lru_init();


	return 0;
}

int kv_finish()
{
	free(Table);
	return 0;
}