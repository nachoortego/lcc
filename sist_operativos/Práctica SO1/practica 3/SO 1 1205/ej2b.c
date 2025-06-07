#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <semaphore.h>
#include <pthread.h>

#define N_FILOSOFOS 5
#define ESPERA 5000000

pthread_mutex_t tenedor[N_FILOSOFOS];

pthread_mutex_t* izq(int i) { return &tenedor[i]; }
pthread_mutex_t* der(int i) { return &tenedor[(i+1) % N_FILOSOFOS]; }

void pensar(int i){
    printf("Filosofo %d pensando...\n", i);
    usleep(random() % ESPERA);
}

void comer(int i){
    printf("Filosofo %d comiendo...\n", i);
    usleep(random() % ESPERA);
}

void tomar_tenedores(int i){
    pthread_mutex_lock(der(i));
    //sleep(1);
    pthread_mutex_lock(izq(i));
}

void tomar_tenedores_Z(int i){
    pthread_mutex_lock(izq(i));
    //sleep(1);
    pthread_mutex_lock(der(i));
}

void dejar_tenedores(int i){
    pthread_mutex_unlock(der(i));
    pthread_mutex_unlock(izq(i));
}

void dejar_tenedores_Z(int i){
    pthread_mutex_unlock(izq(i));
    pthread_mutex_unlock(der(i));
}

void* filosofo(void *arg){
    int i = arg - (void*)0;
    while (1) {
        if(i == 0){
            tomar_tenedores_Z(i);
            comer(i);
            dejar_tenedores_Z(i);
            pensar(i);

        }else{
        tomar_tenedores(i);
        comer(i);
        dejar_tenedores(i);
        pensar(i);
        }
    }
}

int main(){
    pthread_t filo[N_FILOSOFOS];
    int i;

    for (i = 0; i < N_FILOSOFOS; i++)
        pthread_mutex_init(&tenedor[i], NULL);

    for (i = 0; i < N_FILOSOFOS; i++)
        pthread_create(&filo[i], NULL, filosofo, i + (void*)0);

    pthread_join(filo[0], NULL);

    return 0;
}

// a) Puede tomar en deadlock si toman todos el tenedor de la derecha 
// antes de que alguien agarre el de la izquierda

// b)
// Funciona porque cuando el filosofo zurdo toma el tenedor de la izquierda, el filosofo de su izquierda
// no puede tomar ni su tenedor derecho ni su tenedor izquierdo, por lo que siempre al menos uno podrá comer

//c)
