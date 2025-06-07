#include <stdio.h>
#include <pthread.h>

#define B 2
#define K (2*B)

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

volatile int s, r, buf[B];

static inline int diff() { return (K + s - r) % K; }

void* prod(void *_arg) {
    int cur = 0;
    while (1) {
        while (diff() == B);
        pthread_mutex_lock(&mutex);
        buf[s % B] = cur++;
        printf("Escribí %d\n", cur);
        pthread_mutex_unlock(&mutex);
        s = (s+1) % K;
    }
}

void* cons(void *_arg) {
    int cur;
    while (1) {
        while (diff() == 0);
        pthread_mutex_lock(&mutex);
        cur = buf[r % B];
        printf("Leí %d\n", cur);
        pthread_mutex_unlock(&mutex);
        r = (r+1) % K;
    }
}

int main () {

    pthread_t t1, t2;
    pthread_create(&t1, NULL, prod, NULL);
    pthread_create(&t2, NULL, cons, NULL);

    pthread_join(t1, NULL);
    pthread_join(t2, NULL);


    return 0;
}

