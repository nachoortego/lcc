#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  if (argc < 2){
  printf("La cantidad de argumentos es insuficiente\n");
  } 
  else {
    int suma=0;
    for (int i=1; i<argc; i++){
      suma = suma + atoi(argv[i]);
    }
    printf("Cantidad de argumentos: %d, suma de los argumentos: %d\n", argc, suma);
  }
  return 0;
}

/*
Escribir un codigo equivalente en Assembler x86-64.
Nota: La funcion atoi de la libreria stdlib.h convierte una cadena de caracteres a su
valor numerico equivalente (entero). Toma como parametro de entrada la cadena a convertir y
devuelve el valor numerico correspondiente.
*/