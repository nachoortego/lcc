#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid = fork();

    if (pid == 0) {  // Proceso hijo
        printf("Soy el hijo, mi pid es %d ejecutando el ejercicio 1\n", getpid());
        execl("./ej1", "./ej1", NULL);
        perror("execl falló");  // Solo se ejecuta si execl() falla
    } 
    else if (pid > 0) {  // Proceso padre
        wait(NULL);  // Espera a que el hijo termine
        printf("Soy el padre, el hijo terminó y mi pid es %d\n", getpid());
    } 
    else {
        perror("Error al crear el proceso");
    }

    return 0;
}