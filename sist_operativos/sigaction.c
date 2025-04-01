// #include <signal.h>
// int sigaction(int sig, const struct sigaction *act, struct sigaction *oldact);
// sig: La señal a manejar.

// act: Estructura que define el manejador de la señal y otros comportamientos.

// oldact: Estructura para guardar la acción anterior de la señal.

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

// Manejador de SIGTERM
void manejador_SIGTERM(int signo) {
    printf("¡Recibí la señal SIGTERM!\n");
    exit(0);
}

int main() {
    // Configuramos el manejador de SIGTERM
    struct sigaction sa;
    sa.sa_handler = manejador_SIGTERM;
    sa.sa_flags = 0;
    sigemptyset(&sa.sa_mask);  // No bloquear otras señales mientras manejamos

    if (sigaction(SIGTERM, &sa, NULL) == -1) {
        perror("Error al configurar SIGTERM");
        return 1;
    }

    // Enviamos una señal SIGTERM al proceso (a sí mismo)
    printf("Enviando SIGTERM a este proceso...\n");
    kill(getpid(), SIGTERM);  // Enviar SIGTERM al mismo proceso

    // Este código no se ejecutará porque el proceso se detendrá en el manejador
    printf("Este mensaje no se verá.\n");

    return 0;
}
// En este ejemplo, el programa configura un manejador para la señal SIGTERM. Cuando se envía la señal SIGTERM al proceso, el manejador imprime un mensaje y termina el programa. La función sigaction se utiliza para establecer el manejador de la señal y configurar su comportamiento. La función kill se utiliza para enviar la señal SIGTERM al mismo proceso.