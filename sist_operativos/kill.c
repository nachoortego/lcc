#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

int main() {
    pid_t pid = fork();

    if (pid == -1) {
        perror("Error en fork");
        exit(1);
    }
    else if (pid == 0) {
        // Proceso hijo
        while (1) {
            printf("Proceso hijo en ejecución...\n");
            sleep(2);
        }
    }
    else {
        // Proceso padre
        sleep(5);  // Esperamos 5 segundos
        printf("El padre envía SIGTERM al hijo...\n");
        kill(pid, SIGTERM);  // Enviar SIGTERM al hijo
        wait(NULL);  // Esperar a que el hijo termine
    }

    return 0;
}
