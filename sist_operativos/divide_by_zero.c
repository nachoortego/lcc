#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

// Manejador de señal para SIGFPE (Floating Point Exception)
void manejador_division_por_cero(int signo) {
    printf("¡Error! División por cero detectada.\n");
    exit(1);  // Terminamos el programa de manera controlada
}

int main() {
    // Configuramos el manejador de la señal SIGFPE
    if (signal(SIGFPE, manejador_division_por_cero) == SIG_ERR) {
        perror("Error al configurar la señal");
        return 1;
    }

    int a = 10;
    int b = 0;

    // Intentamos dividir por cero
    printf("Intentando dividir %d / %d...\n", a, b);
    int resultado = a / b;  // Esto provocará la excepción SIGFPE

    printf("Resultado: %d\n", resultado);  // Este código nunca se ejecutará

    return 0;
}
