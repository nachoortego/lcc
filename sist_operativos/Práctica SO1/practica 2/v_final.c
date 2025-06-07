#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

#define NUM_VISITANTES 1000

int visitantes = 0;
int turno = 0; //0 = no se asigno turno, indica a que molinete le toca 1 o 2

pthread_mutex_t mutex_visitantes = PTHREAD_MUTEX_INITIALIZER;

void* molinete() {
for(int i=0; i< NUM_VISITANTES/2 ; i++)
{
//lock

pthread_mutex_lock(&mutex_visitantes);


//region critica
visitantes = visitantes + 1;
printf("%d molinete 1\n", visitantes);

pthread_mutex_unlock(&mutex_visitantes);
}
}


void* molinete2() {
for(int i=0; i< NUM_VISITANTES/2 ; i++)
{
//lock

pthread_mutex_lock(&mutex_visitantes);


//region critica
visitantes = visitantes + 1;
printf("%d molinete 2\n", visitantes);

pthread_mutex_unlock(&mutex_visitantes);
}
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