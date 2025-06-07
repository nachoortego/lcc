#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h>

#include "rwlock.h"

#define sleep(n) usleep(1000*(n))

#define M 20
#define N 20
#define ARRLEN (1<<20) /* 1MB */

struct rwlock *rwl;

int arr[ARRLEN];

void * escritor(void *arg)
{
	int i, j;
	int num = arg - (void*)0;
	for (j = 0; j < 100; j++) {
		sleep(random() % 100);

		lock_w(rwl);

		printf("Escritor %d escribiendo\n", num);
		for (i = 0; i < ARRLEN; i++) {
			if (i == ARRLEN/2)
				usleep(50);
			arr[i] = num;
		}

		unlock_w(rwl);
	}
	return NULL;
}

void * lector(void *arg)
{
	int v, i, j;
	int num = arg - (void*)0;
	for (j = 0; j < 100; j++) {
		sleep(random() % 100);

		lock_r(rwl);

		v = arr[ARRLEN-1];
		for (i = ARRLEN-2; i >= 0; i--) {
			if (arr[i] != v)
				break;
		}
		if (i >= 0) {
			printf("Lector %d, error de lectura (%i vs %i)\n", num,
					arr[i], v);
			abort();
		} else {
			printf("Lector %d, dato %d\n", num, v);
		}

		unlock_r(rwl);
	}
	return NULL;
}

int main()
{
	pthread_t lectores[M], escritores[N];
	int i;

	rwl = rwlock_init();

	for (i = 0; i < M; i++)
		pthread_create(&lectores[i], NULL, lector, i + (void*)0);

	for (i = 0; i < N; i++)
		pthread_create(&escritores[i], NULL, escritor, i + (void*)0);

	for (i = 0; i < M; i++) pthread_join(lectores[i], NULL);
	for (i = 0; i < N; i++) pthread_join(escritores[i], NULL);

	rwlock_destroy(rwl);

	return 0;
}
