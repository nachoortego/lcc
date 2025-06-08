#include <semaphore.h>
#include <stdlib.h>
#include "rwlock.h"

/* Read-preferring */

struct rwlock {
	int nr;
	sem_t sn;
	sem_t sl;
};

struct rwlock * rwlock_init()
{
	struct rwlock *rwl = malloc(sizeof *rwl);
	sem_init(&rwl->sn, 0, 1);
	sem_init(&rwl->sl, 0, 1);
	rwl->nr = 0;
	return rwl;
}

void rwlock_destroy(struct rwlock *rwl)
{
	sem_destroy(&rwl->sn);
	sem_destroy(&rwl->sl);
	free(rwl);
}

void lock_r(struct rwlock *rwl)
{
	sem_wait(&rwl->sn);
	if (rwl->nr == 0)
		sem_wait(&rwl->sl);
	rwl->nr++;
	sem_post(&rwl->sn);
}

void unlock_r(struct rwlock *rwl)
{
	sem_wait(&rwl->sn);
	rwl->nr--;
	if (rwl->nr == 0)
		sem_post(&rwl->sl);
	sem_post(&rwl->sn);
}

void lock_w(struct rwlock *rwl)
{
	sem_wait(&rwl->sl);
}

void unlock_w(struct rwlock *rwl)
{
	sem_post(&rwl->sl);
}
