#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

// Manejador de SIGINT
void manejador_SIGINT(int signo) {
    printf("¡Recibí la señal SIGINT!\n");
    exit(0);  // Terminamos el programa
}

int main() {
    // Configuramos el manejador para la señal SIGINT
    if (signal(SIGINT, manejador_SIGINT) == SIG_ERR) {
        perror("Error al configurar la señal");
        return 1;
    }

    printf("Enviando SIGINT a este proceso...\n");
    
    // Enviamos una señal SIGINT al proceso
    raise(SIGINT);  // Llama al manejador de SIGINT

    // Este código no se ejecutará debido a la llamada a raise()
    printf("Este mensaje no se verá.\n");

    return 0;
}
