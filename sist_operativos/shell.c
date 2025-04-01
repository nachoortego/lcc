#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

#define MAX_CMD_LENGTH 1024
#define MAX_ARG_COUNT 100

void ejecutar_comando(char *comando) {
    char *args[MAX_ARG_COUNT];
    char *token;
    int i = 0;

    // Tokenizamos la cadena usando el espacio como delimitador
    token = strtok(comando, " \n");
    while (token != NULL && i < MAX_ARG_COUNT - 1) {
        args[i++] = token;
        token = strtok(NULL, " \n");
    }
    args[i] = NULL;  // El último argumento debe ser NULL para execvp

    // Si el comando es "salir", terminamos la shell
    if (strcmp(args[0], "salir") == 0) {
        printf("Saliendo de la shell...\n");
        exit(0);
    }

    // Creamos un proceso hijo
    pid_t pid = fork();

    if (pid == -1) {
        perror("Error al crear el proceso hijo");
        exit(1);
    } 
    else if (pid == 0) {  // Proceso hijo
        execvp(args[0], args);  // Ejecuta el comando
        perror("Error al ejecutar el comando");  // Si execvp falla
        exit(1);
    } 
    else {  // Proceso padre
        wait(NULL);  // Espera a que el hijo termine
    }
}

int main() {
    char comando[MAX_CMD_LENGTH];

    // Shell principal
    while (1) {
        printf("> ");  // Prompt de la shell
        if (fgets(comando, sizeof(comando), stdin) == NULL) {
            perror("Error al leer la entrada");
            exit(1);
        }

        // Llamamos a la función para ejecutar el comando
        ejecutar_comando(comando);
    }

    return 0;
}
