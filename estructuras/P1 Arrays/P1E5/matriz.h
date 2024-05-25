#ifndef __MATRIZ_H__
#define __MATRIZ_H__

#include <stdlib.h>

typedef struct Matriz_ Matriz;

/**
 * Crea una nueva matriz
 */
Matriz *matriz_crear(size_t numFilas, size_t numColumnas);

/**
 * Destruye una matriz
 */
void matriz_destruir(Matriz *matriz);

/**
 * Obtiene el dato guardado en la posición dada de la matriz
 */
double matriz_leer(Matriz *matriz, size_t fil, size_t col);

/**
 * Modifica el dato guardado en la posición dada de la matriz
 */
void matriz_escribir(Matriz *matriz, size_t fil, size_t col, double val);

/**
 * Obtiene número de filas de la matriz
 */
size_t matriz_num_filas(Matriz *matriz);

/**
 * Obtiene número de columnas de la matriz
 */
size_t matriz_num_columnas(Matriz *matriz);

/**
 * Imprime una matriz por pantalla distinguiendo filas y columnas.
 */
void matriz_mostrar(Matriz *matriz);

/**
 * Dada una matriz y dos posiciones, intercambia las filas de las posiciones
 * dadas.
 */
void matriz_intercambiar_filas(Matriz *matriz, size_t fila1, size_t fila2);

/**
 * Dada una matriz y una posicion mayor o igual a 0, inserta una nueva
 * fila en la posicion dada. Si se excede es agregada al final.
 */
void matriz_insertar_fila(Matriz *matriz, size_t fila);

#endif /* __MATRIZ_H__ */
