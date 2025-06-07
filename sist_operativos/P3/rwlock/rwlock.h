#ifndef __RWLOCK_H__
#define __RWLOCK_H__ 1

#include <semaphore.h>

struct rwlock;

struct rwlock * rwlock_init(void);

void rwlock_destroy(struct rwlock *rwl);

void lock_r(struct rwlock *rwl);
void unlock_r(struct rwlock *rwl);

void lock_w(struct rwlock *rwl);
void unlock_w(struct rwlock *rwl);

#endif
