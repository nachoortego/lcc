#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <assert.h> 

#define NUM_VISITANTES 2000000000

int visitantes = 0;
int turno = 0; // 0 o 1 indica el turno de uno de los molinetes
int flag[2] = {0, 0}; // Si es 1, el proceso tiene intención de entrar en la región crítica

static inline void incl(int *p) {
    asm("lock;incl %0" : "+m"(*p) : : "memory");
    }

void* molineton1(void* arg) {
    for (int i = 0; i < NUM_VISITANTES / 2; i++) {
        incl(&visitantes);
    }
}

void* molineton2(void* arg) {
    for (int i = 0; i < NUM_VISITANTES / 2; i++) {
        incl(&visitantes);
    }
}


int main() {
    pthread_t t0, t1;
    int id0 = 0, id1 = 1; // Identificadores de los molinetes
    
    // Crear los hilos para los molinetes
    pthread_create(&t0, NULL, molineton1, (void*)&id0);
    pthread_create(&t1, NULL, molineton2, (void*)&id1);
    
    // Esperar que los hilos terminen
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    
    printf("La cantidad final es %d\n", visitantes);
    
    return 0;
}
