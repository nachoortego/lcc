#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <math.h>
#include "barrier.h"
#include <stdint.h>

#define N 10      
#define ITERS 20000
#define W 4

struct barrier b;

float arr1[N], arr2[N];

void calor(float *arr, int lo, int hi, float *arr2) {
    for (int i = lo; i < hi; i++) {
        float m = arr[i];
        float l = (i > 0) ? arr[i-1] : m;
        float r = (i < N-1) ? arr[i+1] : m;
        arr2[i] = m + (l - m) / 1000.0 + (r - m) / 1000.0;
    }
}

static inline int cut(int n, int i, int m) {
    return i * (n / m) + fmin(i, n % m);
}

void *thr(void *arg) {
    int id = (int)(uintptr_t)arg;  
    int lo = cut(N, id, W);  
    int hi = cut(N, id + 1, W);  

    for (int i = 0; i < ITERS; i++) {
        printf("Iteracion: %d, id: %d\n", i, id);
        calor(arr1, lo, hi, arr2); 
        barrier_wait(&b);
        calor(arr2, lo, hi, arr1); 
        barrier_wait(&b);
    }

    return NULL;
}

int main() {
    pthread_t threads[N];
    barrier_init(&b, N);
    
    for (int i = 0; i < N; i++) {
        arr1[i] = i + 1.0;
        arr2[i] = 0.0;
    }

    for (int i = 0; i < N; i++) {
        pthread_create(&threads[i], NULL, thr, (void *)(uintptr_t)i);
    }

    for (int i = 0; i < N; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Resultado final de arr1:\n");
    for (int i = 0; i < N; i++) {
        printf("%f ", arr1[i]);
    }
    printf("\n");

    return 0;
}
