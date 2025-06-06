#include "barrier.h"

struct barrier {
    pthread_mutex_t mutex;
    pthread_cond_t cond;
    int count;
    int n;
    int cycle_done; // 0 = esperando, 1 = liberando
};

void barrier_init(struct barrier *b, int n) {
    b->n = n;
    b->count = 0;
    b->cycle_done = 0;
    pthread_mutex_init(&b->mutex, NULL);
    pthread_cond_init(&b->cond, NULL);
}

void barrier_wait(struct barrier *b) {
    pthread_mutex_lock(&b->mutex);

    b->count++;

    if (b->count == b->n) {
        b->cycle_done = 1;
        b->count = 0; // reiniciamos para la próxima ronda
        pthread_cond_broadcast(&b->cond);
    } else {
        while (!b->cycle_done)
            pthread_cond_wait(&b->cond, &b->mutex);
    }

    // Último en salir apaga la bandera
    if (++b->count == b->n) {
        b->cycle_done = 0;
        b->count = 0;
    }

    pthread_mutex_unlock(&b->mutex);
}
