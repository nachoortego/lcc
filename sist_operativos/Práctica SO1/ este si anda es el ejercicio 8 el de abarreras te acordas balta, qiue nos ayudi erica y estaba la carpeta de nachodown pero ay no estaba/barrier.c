    #include <stdio.h>
    #include <unistd.h>
    #include <stdlib.h>
    #include <pthread.h>

    #include "barrier.h"

    void barrier_init(struct barrier *b, int n) {
        b->n = n;
        b->count = 0;
        b->generation = 0;
        pthread_mutex_init(&b->mutex, NULL);
        pthread_cond_init(&b->cond, NULL);
    }

    void barrier_wait(struct barrier *b) {
        pthread_mutex_lock(&b->mutex);

        int gen = b->generation;
        b->count++;

        if (b->count == b->n) {
            b->generation++;
            b->count = 0;
            pthread_cond_broadcast(&b->cond);
        } else {
            while (gen == b->generation) {
                pthread_cond_wait(&b->cond, &b->mutex);
            }
        }

        pthread_mutex_unlock(&b->mutex);
    }