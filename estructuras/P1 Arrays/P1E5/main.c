#include "matriz.h"
#include <stdio.h>

int main() {
  // Ejemplos de uso de interfaz matriz.h

  // Matriz identidad 4x4:
  puts("Matriz identidad 4x4:");
  Matriz *m1 = matriz_crear(4, 4);
  for (size_t i = 0; i < 4; i++)
    matriz_escribir(m1, i, i, 1.0);
  matriz_mostrar(m1);
  puts("");

  // Otra forma:
  puts("Matriz identidad 4x4:");
  Matriz *m2 = matriz_crear(1, 4);
  matriz_escribir(m2, 0, 3, 1.0);
  for (size_t i = 0; i < 3; ++i) {
    matriz_insertar_fila(m2, i);
    matriz_escribir(m2, i, i, 1.0);
  }
  matriz_mostrar(m2);
  puts("");

  // Intercambiar primer y ultima fila:
  puts("Intercambiando primer y ultima fila:");
  matriz_intercambiar_filas(m1, 0, 3);
  matriz_mostrar(m1);
  puts("");

  matriz_destruir(m1);
  matriz_destruir(m2);

  return 0;
}