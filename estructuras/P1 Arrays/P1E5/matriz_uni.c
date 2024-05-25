#include "matriz.h"
#include <assert.h>
#include <stdio.h>

/**
 * Implmentacion utilizando un arreglo unidimensional.
 */

/**
 * Estructura Matriz usando un arreglo dinamico unidimensional. Sus miembros son
 * un puntero a un bloque de memoria para almacenar los elementos de la matriz
 * (elementos), el numero de filas (filas) y el de columnas (columnas). En esta
 * implementacion el elemento de la fila i y columna j se encuentra en
 * elementos[i * columnas + j].
 */
struct Matriz_ {
  double *elementos;
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
  matriz->elementos = malloc(sizeof(double) * numFilas * numColumnas);
  assert(matriz->elementos != NULL);
  matriz->filas = numFilas;
  matriz->columnas = numColumnas;
  for (size_t i = 0; i < numFilas * numColumnas; i++)
    matriz->elementos[i] = 0.0;
  return matriz;
}

/**
 * Destructor de matrices. Su parametro es un puntero a una matriz (matriz).
 * Libera la memoria pedida para matriz y retorna. Es necesario desalocar
 * tambien los elementos.
 */
void matriz_destruir(Matriz *matriz) {
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
  return matriz->elementos[fil * matriz->columnas + col];
}

/**
 * Funcion para escribir en una posicion de una matriz. Sus parametros son un
 * puntero a una matriz (matriz), un indice de fila (fil), un indice de columna
 * (col) y un valor (val). Escribe el valor en matriz en la posicion dada y
 * retorna.
 */
void matriz_escribir(Matriz *matriz, size_t fil, size_t col, double val) {
  assert(col < matriz->columnas && fil < matriz->filas);
  matriz->elementos[fil * matriz->columnas + col] = val;
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
  for (size_t i = 0; i < filas * columnas; i++) {
    printf("%0.2f, ", matriz->elementos[i]);
    if ((i + 1) % columnas == 0)
      puts("");
  }
}

/**
 * Funcion para intercambiar dos filas de una matriz. Sus parametros son un
 * puntero a una matriz (matriz) y dos indices de fila (fila1, fila2).
 * Intercambia las filas en los indices fila1 y fila2 de matriz, elemento por
 * elemento, y retorna.
 */
void matriz_intercambiar_filas(Matriz *matriz, size_t fila1, size_t fila2) {
  assert(fila1 < matriz->filas && fila2 < matriz->filas);
  size_t columnas = matriz_num_columnas(matriz);
  double temp;
  for (size_t i = 0; i < columnas; i++) {
    temp = matriz_leer(matriz, fila1, i);
    matriz_escribir(matriz, fila1, i, matriz_leer(matriz, fila2, i));
    matriz_escribir(matriz, fila2, i, temp);
  }
}

/**
 * Funcion para insertar una fila en una posicion dada. Sus parametros son un
 * puntero a una matriz (matriz) y un indice de fila (fila). Es necesario
 * realocar los elementos de matriz para contener la nueva fila, que
 * inicialmente se inserta como ultima fila. Si fila < matriz->filas, entonces
 * todos los elementos en el indice fila o posterior deben ser desplazadas a la
 * fila siguiente, elemento por elemento (esto se realiza de atras para adelante
 * para evitar pisar los elementos). La nueva fila se rellena con ceros  y se 
 * retorna.
 */
void matriz_insertar_fila(Matriz *matriz, size_t fila) {
  size_t filas = matriz_num_filas(matriz) + 1;
  size_t columnas = matriz_num_columnas(matriz);
  matriz->elementos =
      realloc(matriz->elementos, sizeof(double) * columnas * filas);
  assert(matriz->elementos != NULL);
  matriz->filas++;
  if (fila < filas - 1)
    for (size_t i = filas * columnas - 1; i >= (fila + 1) * columnas; i--)
      matriz->elementos[i] = matriz->elementos[i - columnas];
  else
    fila = filas - 1;
  for (size_t i = 0; i < columnas; i++)
    matriz_escribir(matriz, fila, i, 0.0);
}
