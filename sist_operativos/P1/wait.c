#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main() {
  pid_t pid = fork(); // Crea un proceso hijo

  if (pid == -1) {
    perror("Error en fork");
    return 1;
  } 
  else if (pid == 0) { // Código del proceso hijo
    printf("Soy el hijo (PID: %d), ejecutando...\n", getpid());
    sleep(2); // Simula trabajo del hijo
    printf("Hijo (PID: %d) finalizado.\n", getpid());
    exit(0); // Termina exitosamente
  } 
  else { // Código del proceso padre
    printf("Soy el padre (PID: %d), esperando al hijo (PID: %d)...\n", getpid(), pid);
    int status;
    wait(&status); // Espera al hijo

    if (WIFEXITED(status)) { // Verifica si terminó normalmente
      printf("Hijo terminó con código de salida %d\n", WEXITSTATUS(status));
    } else {
      printf("Hijo terminó de manera anormal\n");
    }
    
    printf("Padre finalizado.\n");
  }

  return 0;
}
