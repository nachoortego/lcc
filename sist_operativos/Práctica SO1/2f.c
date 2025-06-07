#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    // Solicitar 1GB de memoria
    void *ptr = malloc(1L * 1024 * 1024 * 1024);  // 1GB

    if (ptr == NULL) {
        perror("Error al asignar memoria");
        return 1;
    }

    printf("Mi PID es %d\n", getpid());

    printf("Memoria de 1GB reservada.\n");

    while(1) {
        sleep(1);  // El padre duerme, no hace wait() ni termina
    }

    // No usar la memoria solicitada, solo reservada
    // Debería ver que el proceso ha aumentado su uso de memoria virtual
    return 0;
}