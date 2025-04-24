#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>

void INThandler(int sig);

int main(void)
{
    // Registramos el manejador para la señal SIGINT (Ctrl-C)
    signal(SIGINT, INThandler);

    // El programa sigue en un bucle infinito
    while (1)
        sleep(10);  // Duerme por 10 segundos para mantener el programa activo
}

void INThandler(int sig)
{
    char c;

    // Volver a registrar el manejador para SIGINT en caso de que se vuelva a presionar Ctrl-C
    signal(SIGINT, INThandler);

    // Mostrar el mensaje cuando se detecta Ctrl-C
    printf("OUCH, did you hit Ctrl-C?\n"
           "Do you really want to quit? [y/n] ");

    // Leer la respuesta del usuario
    c = getchar();

    if (c == 'y' || c == 'Y') {
        // Si la respuesta es 'y' o 'Y', salir del programa
        exit(0);
    } else {
        // Si la respuesta no es 'y', volver a configurar el manejador para que capture Ctrl-C nuevamente
        signal(SIGINT, INThandler);
        getchar();  // Consumir el salto de línea residual
    }
}
