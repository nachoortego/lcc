#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main() {
    pid_t pid = fork();

    if (pid == 0) {  // Proceso hijo
        printf("Soy el hijo, mi PID es %d\n", getpid());
        // El hijo termina (puede usar exit o return en el main)
        printf("El hijo está terminando...\n");
        exit(0);  // O simplemente retornar del main también termina el proceso hijo
    } 
    else if (pid > 0) {  // Proceso padre
        printf("Soy el padre, mi PID es %d\n", getpid());
        // El padre duerme indefinidamente
        printf("El padre está durmiendo indefinidamente...\n");
        while(1) {
            sleep(1);  // El padre duerme, no hace wait() ni termina
        }
    } 
    else {
        perror("Error al crear el proceso");
        return 1;
    }

    return 0;
}