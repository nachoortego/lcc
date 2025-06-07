#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>

#include "barrier.h"

void barrier_init(struct barrier *b, int n){
    b->n = n;
    b->cont = 0;
    pthread_cond_init(&b->cond, NULL);
    pthread_mutex_init(&b->mutex, NULL);
}

void barrier_wait(struct barrier *b) {
    pthread_mutex_lock(&b->mutex); 

    b->cont++;

    if (b->cont == b->n) {
        pthread_cond_broadcast(&b->cond);
        b->cont = 0;
    } else {
        while (b->cont < b->n) {
            pthread_cond_wait(&b->cond, &b->mutex);
        }
    }

    pthread_mutex_unlock(&b->mutex);
}