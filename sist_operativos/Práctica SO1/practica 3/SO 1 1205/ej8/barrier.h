#ifndef __BARRIER_H__
#define __BARRIER_H__ 1

#include <pthread.h>

struct barrier {
    int n;
    int cont;
	pthread_cond_t cond;
    pthread_mutex_t mutex;
};

void barrier_init(struct barrier *b, int n);

void barrier_wait(struct barrier *b);

#endif