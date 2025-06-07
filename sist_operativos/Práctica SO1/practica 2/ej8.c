// Ej. 8. En la siguiente implementaci´on del jard´ın ornamental (asumiendo dos molinetes), agregue
// estrat´egicamente algunos sleep() para obtener el m´ınimo valor posible de visitantes. Puede usar
// condicionales.


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

#define NUM_VISITANTES 1000

int visitantes = 0;
int turno = 0; //0 = no se asigno turno, indica a que molinete le toca 1 o 2

pthread_mutex_t mutex_visitantes = PTHREAD_MUTEX_INITIALIZER;


void * proc(void *arg) {
    int i;
    int id = arg - (void*)0;
    for (i = 0; i < N; i++) {
    int c;
    /* sleep? */
    c = visitantes;
    /* sleep? */
    visitantes = c + 1;
    /* sleep? */
    }
    return NULL;
}


int main() {
    pthread_t t0, t1;

    pthread_create(&t0, NULL, molinete, NULL);
    pthread_create(&t1, NULL, molinete2, NULL);
    
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);

    pthread_mutex_destroy(&mutex_visitantes);

    printf("La cantidad final es %d\n", visitantes);

return 0;
}