#include "matriz.h"
#include <assert.h>
#include <stdio.h>

/**
 * Implementacion utilizando un arreglo bidimensional.
 */

/**
 * Estructura Matriz usando un arreglo dinamico bidimensional. Sus miembros son
 * un puntero a un bloque de memoria que almacena punteros a double (elementos),
 * el numero de filas (filas) y el de columnas (columnas). En esta
 * implementacion el elemento de la fila i y columna j se encuentra en
 * elementos[i][j]
 */
struct Matriz_ {
  double **elementos;
  size_t filas, columnas;
};

/**
 * Constructor de matrices. Sus parametros son el numero de filas (numFilas) y
 * el de columnas (numColumnas), que deben ser numeros positivos. Retorna un
 * puntero a una matriz de tamaño numFilas x numColumnas rellena con ceros. Es
 * necesario alocar tambien memoria para sus elementos.
 */
Matriz *matriz_crear(size_t numFilas, size_t numColumnas) {
  assert(numColumnas > 0 && numFilas > 0);
  Matriz *matriz = malloc(sizeof(Matriz));
  assert(matriz != NULL);
  matriz->elementos =
      malloc(sizeof(double *) * numFilas); // matriz->elementos es un puntero a
                                           // un arreglo de punteros a double
  assert(matriz->elementos);
  for (size_t i = 0; i < numFilas; i++) {
    matriz->elementos[i] =
        malloc(sizeof(double) * numColumnas); // matriz->elementos[i] es un
                                              // puntero a un arreglo de double
    assert(matriz->elementos[i]);
    for (size_t j = 0; j < numColumnas; j++)
      matriz->elementos[i][j] = 0.0;
  }
  matriz->filas = numFilas;
  matriz->columnas = numColumnas;
  return matriz;
}

/**
 * Destructor de matrices. Su parametro es un puntero a una matriz (matriz).
 * Libera la memoria pedida para matriz y retorna. Es necesario desalocar
 * tambien los elementos.
 */
void matriz_destruir(Matriz *matriz) {
  for (size_t i = 0; i < matriz->filas; i++)
    free(matriz->elementos[i]);
  free(matriz->elementos);
  free(matriz);
}

/**
 * Funcion para leer en una posicion de una matriz. Sus parametros son un
 * puntero a una matriz (matriz), un indice de fila (fil) y un indice de columna
 * (col). Retorna el dato guardado en matriz en la posicion dada.
 */
double matriz_leer(Matriz *matriz, size_t fil, size_t col) {
  assert(col < matriz->columnas && fil < matriz->filas);
  return (matriz->elementos[fil][col]);
}

/**
 * Funcion para escribir en una posicion de una matriz. Sus parametros son un
 * puntero a una matriz (matriz), un indice de fila (fil), un indice de columna
 * (col) y un valor (val). Escribe el valor en matriz en la posicion dada y
 * retorna.
 */
void matriz_escribir(Matriz *matriz, size_t fil, size_t col, double val) {
  assert(col < matriz->columnas && fil < matriz->filas);
  matriz->elementos[fil][col] = val;
}

/**
 * Obervador del numero de filas de una matriz. Su parametro es un puntero a una
 * matriz (matriz) y retorna el miembro filas de matriz.
 */
size_t matriz_num_filas(Matriz *matriz) { return matriz->filas; }

/**
 * Obervador del numero de columnas de una matriz. Su parametro es un puntero a
 * una matriz (matriz) y retorna el miembro columnas de matriz.
 */
size_t matriz_num_columnas(Matriz *matriz) { return matriz->columnas; }

/**
 * Funcion para imprimir por pantalla una matriz. Su parametro es un puntero a
 * una matriz (matriz). Imprime la matriz separando los elementos con ',' y las
 * filas con '\n' y retorna.
 */
void matriz_mostrar(Matriz *matriz) {
  size_t filas = matriz_num_filas(matriz);
  size_t columnas = matriz_num_columnas(matriz);
  for (size_t i = 0; i < filas; i++) {
    for (size_t j = 0; j < columnas; j++) {
      printf("%0.2f, ", matriz_leer(matriz, i, j));
    }
    puts("");
  }
}

/**
 * Funcion para intercambiar dos filas de una matriz. Sus parametros son un
 * puntero a una matriz (matriz) y dos indices de fila (fila1, fila2).
 * Intercambia los punteros de los indices fila1 y fila2 de matriz y retorna.
 * Notar que no es necesario intercambiar elemento por elemento.
 */
void matriz_intercambiar_filas(Matriz *matriz, size_t fila1, size_t fila2) {
  double *temp;
  temp = matriz->elementos[fila1];
  matriz->elementos[fila1] = matriz->elementos[fila2];
  matriz->elementos[fila2] = temp;
}

/**
 * Funcion para insertar una fila en una posicion dada. Sus parametros son un
 * puntero a una matriz (matriz) y un indice de fila (fila). Es necesario
 * realocar los elementos de matriz para contener la nueva fila, que
 * inicialmente se inserta como ultima fila. Si fila < matriz->filas, entonces
 * todas las filas de indice fila o posterior deben ser desplazadas a la fila
 * siguiente (esto se realiza de atras para adelante para evitar pisar los
 * punteros). Notar que no es necesario intercambiar las filas elemento por
 * elemento. La nueva fila se rellena con ceros y se retorna.
 */
void matriz_insertar_fila(Matriz *matriz, size_t fila) {
  size_t filas = matriz_num_filas(matriz) + 1;
  size_t columnas = matriz_num_columnas(matriz);
  matriz->elementos = realloc(matriz->elementos, sizeof(double *) * filas);
  assert(matriz->elementos != NULL);
  matriz->filas++;
  if (fila < filas - 1)
    for (size_t i = filas - 1; fila < i; i--)
      matriz->elementos[i] = matriz->elementos[i - 1];
  else
    fila = filas - 1;
  matriz->elementos[fila] = malloc(sizeof(double) * columnas);
  assert(matriz->elementos[fila] != NULL);
  for (size_t i = 0; i < columnas; i++)
    matriz_escribir(matriz, fila, i, 0.0);
}
