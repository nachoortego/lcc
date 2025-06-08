#ifndef __KV_H
#define __KV_H 1

#include <stdbool.h>
#include "ll.h"
#include "hash.h"

struct lru;

struct kv {
	int klen, vlen;
	char *k, *v;

	/*
	 * El hash completo, sirve para una desigualdad rápida
	 * y para rehashear
	 */
	u64 hash;
	/* Número de bin */
	int bin;
	/* Nodo en lista de rebalse (aka bin) */
	struct list list;
	/* Nodo en lista LRU */
	struct list lru;
	/*
	 * Reference count para liberar. La referencia desde
	 * la tabla cuenta como 1.
	 */
	uint32_t nrefs;
};

void * galloc(size_t sz);
void * memdup(const void *p, int len);

int kv_init(int tablesz);
int kv_finish(void);

void kv_clear_all(void);

/* Toma posesión de [k] y [v]. */
int kv_add(int klen, char *k, int vlen, char *v);

void kv_release(struct kv *kv);

/*
 * Estas funciones devuelven un struct kv * linkeado en la tabla,
 * el llamante DEBE llamar a kv_release al terminar de usar el objeto
 * (cuando no sea NULL).
 */
struct kv * kv_lookup(int klen, const char *k);
struct kv * kv_take(int klen, const char *k);

/* devuelve true si estaba, false si no estaba */
bool kv_remove(int klen, const char *k);

long kv_keys(void);

#endif
