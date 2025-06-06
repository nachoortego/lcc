#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <pthread.h>

#define M 5
#define N 5
#define SZ 8

/*
 * El buffer guarda punteros a enteros, los
 * productores los consiguen con malloc() y los
 * consumidores los liberan con free()
 */
int *buffer[SZ];
int i = 0; // Índice del buffer
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t no_vacio_cond = PTHREAD_COND_INITIALIZER;
pthread_cond_t no_lleno_cond = PTHREAD_COND_INITIALIZER;

void enviar(int *p)
{
  pthread_mutex_lock(&mutex);

  while (i == SZ)  // Buffer lleno
    pthread_cond_wait(&no_lleno_cond, &mutex);

  buffer[i] = p; // apilar
  i++;

  pthread_cond_signal(&no_vacio_cond);
  pthread_mutex_unlock(&mutex);
}

int *recibir()
{
  int *v;

  pthread_mutex_lock(&mutex);

  while (i == 0)  // Buffer vacío
    pthread_cond_wait(&no_vacio_cond, &mutex);

  i--; // desapilar primero
  v = buffer[i];

  pthread_cond_signal(&no_lleno_cond);
  pthread_mutex_unlock(&mutex);
  return v;
}

void * prod_f(void *arg)
{
	int id = arg - (void*)0;
	while (1) {
		sleep(random() % 3);

		int *p = malloc(sizeof *p);
		*p = random() % 100;
		printf("Productor %d: produje %p->%d\n", id, p, *p);
		enviar(p);
	}
	return NULL;
}

void * cons_f(void *arg)
{
	int id = arg - (void*)0;
	while (1) {
		sleep(random() % 3);

		int *p = recibir();
		printf("Consumidor %d: obtuve %p->%d\n", id, p, *p);
		free(p);
	}
	return NULL;
}

int main()
{
  srand(time(NULL));
	pthread_t productores[M], consumidores[N];
	int i;

	for (i = 0; i < M; i++)
		pthread_create(&productores[i], NULL, prod_f, i + (void*)0);

	for (i = 0; i < N; i++)
		pthread_create(&consumidores[i], NULL, cons_f, i + (void*)0);

	pthread_join(productores[0], NULL); /* Espera para siempre */
	return 0;
}