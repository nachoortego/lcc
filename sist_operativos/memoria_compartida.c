#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>  // mmap
#include <sys/stat.h>  // fstat
#include <fcntl.h>     // shm_open
#include <unistd.h>    // fork, ftruncate
#include <string.h>

#define SHM_NAME "/mi_memoria"  // Nombre de la memoria compartida
#define SHM_SIZE 1024  // Tamaño en bytes

int main() {
    int fd = shm_open(SHM_NAME, O_CREAT | O_RDWR, 0666);
    if (fd == -1) {
        perror("shm_open failed");
        return 1;
    }

    ftruncate(fd, SHM_SIZE);  // Ajustar tamaño

    void *ptr = mmap(NULL, SHM_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (ptr == MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }

    pid_t pid = fork();

    if (pid < 0) {
        perror("fork failed");
        return 1;
    }

    if (pid == 0) {  // Proceso hijo
        sleep(1);  // Espera que el padre escriba
        printf("Hijo leyó: %s\n", (char *)ptr);
    } else {  // Proceso padre
        char mensaje[] = "Hola desde el padre!";
        strcpy((char *)ptr, mensaje);  // Escribe en memoria compartida
        wait(NULL);  // Espera al hijo
        shm_unlink(SHM_NAME);  // Elimina la memoria compartida
    }

    return 0;
}
