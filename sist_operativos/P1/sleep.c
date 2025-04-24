#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
  if (argc != 3) {
    fprintf(stderr, "Uso: %s <ruta_binario> <tiempo_segundos>\n", argv[0]);
    return 1;
  }

  char *binario = argv[1];
  int tiempo = atoi(argv[2]);

  if (tiempo <= 0) {
    fprintf(stderr, "El tiempo debe ser un número positivo.\n");
    return 1;
  }

  while (1) {
    pid_t pid = fork();

    if (pid == -1) {
      perror("Error en fork");
      return 1;
    } 
    else if (pid == 0) { // Proceso hijo
      execl(binario, binario, NULL);
      perror("Error en execl");
      return 1; // Si execl falla, el hijo debe terminar
    }

    // Proceso padre espera y duerme antes de repetir
    sleep(tiempo);
  }

  return 0;
}
