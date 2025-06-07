#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <pthread.h>
#include <semaphore.h>

sem_t tabaco, papel, fosforos, otra_vez;

void agente() {
    printf("AGENTE\n");
    while (1) {
        sem_wait(&otra_vez);
        int caso = random() % 3;
        printf("Caso: %d\n", caso);
        if (caso != 0) sem_post(&fosforos);
        if (caso != 1) sem_post(&papel);
        if (caso != 2) sem_post(&tabaco);
    }
}

void fumar(int fumador) {
    printf("Fumador %d: Puf! Puf! Puf!\n", fumador);
    sleep(1);
}

void* fumador1(void *arg) {
    while (1) {
        sem_wait(&tabaco);
        while(sem_trywait(&papel)){
            sem_post(&tabaco);
            sem_wait(&tabaco);
        }
        
        fumar(1);
        sem_post(&otra_vez);
    }   
}

void* fumador2(void *arg) {
    while (1) {
        sem_wait(&fosforos);
        while(sem_trywait(&tabaco)){
            sem_post(&fosforos);
            sem_wait(&fosforos);
        }
        fumar(2);
        sem_post(&otra_vez);
    }
}

void* fumador3(void *arg) {
    while (1) {
        sem_wait(&papel);
        while(sem_trywait(&fosforos)){
            sem_post(&papel);
            sem_wait(&papel);
        }
        fumar(3);
        sem_post(&otra_vez);
    }
}

int main() {
    pthread_t s1, s2, s3;
    srand(time(NULL));
    sem_init(&tabaco, 0, 0);
    sem_init(&papel, 0, 0);
    sem_init(&fosforos, 0, 0);
    sem_init(&otra_vez, 0, 1);
    pthread_create(&s1, NULL, fumador1, NULL);
    pthread_create(&s2, NULL, fumador2, NULL);
    pthread_create(&s3, NULL, fumador3, NULL);
    agente();
    return 0;
}

/* a- ocurre un deadlock cuando dos fumadores lockean recursos distintos y luego
esperan al segundo el cual ya fue tomado por otro fumador*/

/* b- no se pueden ordenar para que nunca haya deadlock, siempre va a caer en un 
caso donde se blockeen */