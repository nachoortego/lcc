#include "avl.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

/**
 * Casos de prueba para arboles AVL
 */

 /**
  * Funciones para usar arboles AVL con datos de tipo int *
  */
static void* copiar_puntero_entero(void* i) {
  int* p = malloc(sizeof(int));
  *p = *(int*)i;
  return p;
}
static int comparar_puntero_entero(void* i1, void* i2) {
  return (*(int*)i1 - *(int*)i2);
}
static void destruir_puntero_entero(void* i) { free(i); }
static void imprimir_puntero_entero(void* i,
  __attribute__((unused)) void* extra) {
  printf("%d ", *(int*)i);
}

int main() {

  // caso de prueba 1:
  // se insertan 500 enteros aleatorios entre 0 y 999,
  // validando que cada arbol intermedio sea AVL
  AVL arbol = avl_crear(copiar_puntero_entero, comparar_puntero_entero,
    destruir_puntero_entero);
  for (int i = 0; i < 500; ++i) {
    int i = rand() % 1000;
    avl_insertar(arbol, &i);
    assert(avl_validar(arbol) == 1);
  }
  avl_destruir(arbol);

  // caso de prueba 2:
  // arbol AVL de la practica,
  // imprimiendo en preorden cada arbol intermedio
  AVL arbol2 = avl_crear(copiar_puntero_entero, comparar_puntero_entero,
    destruir_puntero_entero);
  int numeros[] = { 10, 20, 15, 25, 30, 16, 18, 19 };
  for (int i = 0; i < 8; ++i) {
    avl_insertar(arbol2, numeros + i);
    printf("Se inserto %d. Recorrido preorden: ", numeros[i]);
    avl_recorrer(arbol2, AVL_RECORRIDO_PRE, imprimir_puntero_entero, NULL);
    puts("");
  }

  // caso de prueba 3:
  // buscar numeros en el arbol
  int otrosNumeros[] = { -50, -4, 5, 14, 27, 56 };
  for (int i = 0; i < 8; ++i)
    assert(avl_buscar(arbol2, numeros + i) == 1);
  for (int i = 0; i < 6; ++i)
    assert(avl_buscar(arbol2, otrosNumeros + i) == 0);

  avl_destruir(arbol2);

  puts("Ok");

  return 0;
}