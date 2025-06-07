#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>

int main() {
    int fd = open("archivo.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd == -1) {
        perror("Error al abrir el archivo");
        return 1;
    }

    int fd_dup = dup(fd);  // Duplicamos el file descriptor
    if (fd_dup == -1) {
        perror("Error al duplicar el descriptor");
        return 1;
    }

    write(fd, "Hola desde fd\n", 14);      // Escribimos con el descriptor original
    write(fd_dup, "Hola desde fd_dup\n", 18);  // Escribimos con el descriptor duplicado

    close(fd);  // Cerramos el descriptor original

    write(fd_dup, "Sigo escribiendo\n", 17);  // fd_dup sigue funcionando

    close(fd_dup);  // Ahora sí se libera el recurso


    int fd_backup = dup(1);  // Duplicamos stdout

    if (fd_backup == -1) {
        perror("Error al duplicar stdout");
        return 1;
    }

    printf("Esto se imprimirá en la terminal\n");

    close(fd_backup);  // Cerramos stdout original

    printf("Esto NO se imprimirá en la terminal\n");  // No se verá en pantalla

    dup2(fd_backup, 1);  // Restauramos stdout

    printf("stdout ha sido restaurado\n");

    close(fd_backup);  // Cerramos el backup

    return 0;
}