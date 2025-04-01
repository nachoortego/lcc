#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

// Manejador de SIGINT
void manejador_SIGINT(int signo) {
    printf("¡Señal SIGINT recibida! Terminando el programa...\n");
    exit(0);
}

int main() {
    // Configuramos el manejador de SIGINT
    if (signal(SIGINT, manejador_SIGINT) == SIG_ERR) {
        perror("Error al configurar SIGINT");
        return 1;
    }

    // Bucle infinito esperando la señal SIGINT
    while (1) {
        printf("Esperando señal SIGINT... (Ctrl+C)\n");
        sleep(1);
    }

    return 0;
}