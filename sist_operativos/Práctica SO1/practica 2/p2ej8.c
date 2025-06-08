#include <pthread.h>
#include <unistd.h>
#include <stdio.h>

#define N 20000
int visitantes = 0;

void * molinete(void *arg) {
    int i;
    int id = arg - (void*)0;
    for (i = 0; i < N/2; i++) {
        int c;
        c = visitantes;
        sleep(0.005);
        visitantes = c + 1;
    }
    
    return NULL;
}


int main() {
pthread_t t0, t1;
pthread_create(&t0, NULL, molinete, NULL);
pthread_create(&t1, NULL, molinete, NULL);
pthread_join(t0, NULL);
pthread_join(t1, NULL);

printf("La cantidad final es %d\n", visitantes);

return 0;
}
