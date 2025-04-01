#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main() {
    int fd[2];  // fd[0] es para leer, fd[1] es para escribir
    pid_t pid;
    
    if (pipe(fd) == -1) {  // Creamos el pipe
        perror("pipe failed");
        return 1;
    }

    pid = fork();  // Creamos un proceso hijo
    
    if (pid < 0) {
        perror("fork failed");
        return 1;
    }

    if (pid == 0) {  // Código del hijo
        close(fd[1]);  // Cierra el lado de escritura (no lo usará)
        
        char buffer[100];
        read(fd[0], buffer, sizeof(buffer));  // Lee datos del pipe
        printf("Hijo recibió: %s\n", buffer);

        close(fd[0]);  // Cierra el lado de lectura
    } else {  // Código del padre
        close(fd[0]);  // Cierra el lado de lectura (no lo usará)

        char mensaje[] = "Hola desde el padre!";
        write(fd[1], mensaje, sizeof(mensaje));  // Escribe en el pipe
        
        close(fd[1]);  // Cierra el lado de escritura
    }

    return 0;
}
