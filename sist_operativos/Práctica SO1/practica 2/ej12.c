#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

pthread_mutex_t a = PTHREAD_MUTEX_INITIALIZER;

void * foo(void *_arg) {
    pthread_mutex_lock(&a);
    printf("Foo!\n");
    pthread_mutex_unlock(&a);
    
    return NULL;
}

int main() {
    pthread_t th;
    pthread_create(&th, NULL, foo, NULL);
    
    pthread_mutex_t b = a;
    sleep(1);
    pthread_mutex_lock(&b);
    printf("Bar!\n");
    pthread_mutex_unlock(&b);
    
    pthread_join(th, NULL);
    sleep(1);
    return 0;
}