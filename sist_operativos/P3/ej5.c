#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>

#define SILLAS 5
#define CLIENTES 20
#define ESPERA 500000

sem_t sillas_disponibles;
sem_t sem_cliente_listo;
sem_t sem_pago;

pthread_mutex_t mutex_barbero = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t barbero_despertar = PTHREAD_COND_INITIALIZER;

int barbero_dormido = 0;

void dormir() {
    pthread_mutex_lock(&mutex_barbero);
    barbero_dormido = 1;
    printf("Barbero durmiendo...\n");
    while(barbero_dormido)
        pthread_cond_wait(&barbero_despertar, &mutex_barbero);
    pthread_mutex_unlock(&mutex_barbero);
}

void cortando() {
    printf("Barbero cortando...\n");
    usleep(random() % ESPERA);
}

void me_cortan() {
    printf("Cliente me cortan...\n");
    usleep(random() % ESPERA);
}

void pagando() {
    printf("Cliente pagado...\n");
    usleep(random() % ESPERA);
}

void me_pagan() {
    printf("Barbero me pagan...\n");
    usleep(random() % ESPERA);
}

void* cliente(void* arg) {
    usleep(random() % ESPERA);

    if (sem_trywait(&sillas_disponibles) == -1) {
        printf("Cliente se fue (no hay sillas).\n");
        return NULL;
    }

    pthread_mutex_lock(&mutex_barbero);
    if (barbero_dormido) {
        barbero_dormido = 0;
        pthread_cond_signal(&barbero_despertar);
    }
    pthread_mutex_unlock(&mutex_barbero);

    sem_post(&sem_cliente_listo);  // aviso que estoy listo para cortarme

    me_cortan();
    sem_wait(&sem_pago);  // espero a que el barbero me diga de pagar
    pagando();

    sem_post(&sillas_disponibles);  // libero la silla
    return NULL;
}

void* barbero(void* arg) {
    while (1) {
        if (sem_trywait(&sem_cliente_listo) == -1) {
            dormir();  // duerme si no hay clientes
            continue;
        }

        cortando();
        sem_post(&sem_pago);  // aviso al cliente que puede pagar
        me_pagan();
    }
}

int main() {
    pthread_t hilo_barbero;
    pthread_t hilos_clientes[CLIENTES];

    sem_init(&sillas_disponibles, 0, SILLAS);
    sem_init(&sem_cliente_listo, 0, 0);
    sem_init(&sem_pago, 0, 0);

    pthread_create(&hilo_barbero, NULL, barbero, NULL);

    for (int i = 0; i < CLIENTES; i++)
        pthread_create(&hilos_clientes[i], NULL, cliente, NULL);

    for (int i = 0; i < CLIENTES; i++)
        pthread_join(hilos_clientes[i], NULL);

    // Nota: El barbero se queda en un bucle infinito en esta versión.
    // Podrías implementar una señal de corte si querés terminarlo correctamente.

    return 0;
}
