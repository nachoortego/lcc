#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <stdlib.h>

struct channel {
    int msg;
    sem_t puede_escribir; // iniciado en 1
    sem_t leido;          // iniciado en 0
};

void channel_init(struct channel *c) {
    sem_init(&c->puede_escribir, 0, 0); // hay espacio para escribir
    sem_init(&c->leido, 0, 0);          // no hay dato aún
}

void chan_write(struct channel *c, int v) {
    sem_wait(&c->puede_escribir); // esperar a que haya lector esperándolo
    c->msg = v;
    sem_wait(&c->leido)           // espera que lea
}

int chan_read(struct channel *c) {
    sem_post(&c->puede_escribir); // permitir otro write
    int v = c->msg;
    sem_post(&c->leido);          // avisa que leyo
    return v;
}