// Ej. 10. Implementar un programa con dos threads que suman los elementos de un arreglo compartido usando pthread mutex t para evitar race conditions.

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <assert.h> 

pthread_mutex_t mutex_arr = PTHREAD_MUTEX_INITIALIZER;
int arr[] = {1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7, 1, 2, 3, 4, 5, 6, 7};
int total = 0, n = 70;

void* sum_arr1() {
    for(int i = 0; i < n / 2; i++) {
        pthread_mutex_lock(&mutex_arr);
        total += arr[i];
        pthread_mutex_unlock(&mutex_arr);
        printf("2\n");
    }
    return NULL;
}

void* sum_arr2() {
    for(int i = n/2;i < n; i++) {
        pthread_mutex_lock(&mutex_arr);
        total += arr[i];
        pthread_mutex_unlock(&mutex_arr);
        printf("1\n");
    }
    return NULL;
}

int main() {
    pthread_t t0, t1;
    
    pthread_create(&t0, NULL, sum_arr1, NULL);
    pthread_create(&t1, NULL, sum_arr2, NULL);
    
    pthread_join(t0, NULL);
    pthread_join(t1, NULL);
    
    pthread_mutex_destroy(&mutex_arr);
    
    printf("La cantidad final es %d\n", total);
    
    return 0;
}