#include "bstree.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Casos de prueba para arboles de busqueda binaria generales
 */

static void *copiar_entero(void *dato) {
  int *nuevo_dato = malloc(sizeof(int));
  if (nuevo_dato == NULL) {
    fprintf(stderr, "Error: no se pudo asignar memoria\n");
    exit(EXIT_FAILURE);
  }
  *nuevo_dato = *((int *)dato);
  return nuevo_dato;
}
static int comparar_entero(void *dato1, void *dato2) {
  int num1 = *((int *)dato1);
  int num2 = *((int *)dato2);
  return num1 - num2;
}
static void destruir_entero(void *dato) {
    free(dato);
}
static void imprimir_entero(void *dato, __attribute__((unused)) void *extra) {
  /* __attribute__((unused)) le dice al compilador que esta variable puede no
   * ser usada, de esta forma las banderas no tiran warnings.*/
  printf("%d ", *((int *)dato));
}

int main() {
  int arr[7] = {1, 2, 5, 7, 4, 3, 6};
  // Creamos un arbol vacio y le insertamos las palabras
  BSTree arbol = bstee_crear();
  for (int i = 0; i < 7; i++)
    arbol = bstree_insertar(arbol, &arr[i], copiar_entero, comparar_entero); // Pasa la dirección de memoria de arr[i]

  // Imprimir el arbol inorden (alfabetico)
  printf("Recorrido inorden: ");
  bstree_recorrer(arbol, BTREE_RECORRIDO_IN, imprimir_entero, NULL);
  puts("");

  printf("Elimino 5: ");
  bstree_eliminar_balta(arbol, &arr[2], comparar_entero, destruir_entero); // Pasa la dirección de memoria de arr[3]
  bstree_recorrer(arbol, BTREE_RECORRIDO_IN, imprimir_entero, NULL);
  puts("");

  printf("Elimino 4: ");
  bstree_eliminar_balta(arbol, &arr[4], comparar_entero, destruir_entero); // Pasa la dirección de memoria de arr[3]
  bstree_recorrer(arbol, BTREE_RECORRIDO_IN, imprimir_entero, NULL);
  puts("");

  printf("Elimino 6: ");
  bstree_eliminar_balta(arbol, &arr[6], comparar_entero, destruir_entero); // Pasa la dirección de memoria de arr[5]
  bstree_recorrer(arbol, BTREE_RECORRIDO_IN, imprimir_entero, NULL);
  puts("");

  // Destruir arbol
  bstree_destruir(arbol, destruir_entero);

  return 0;
}


/*
 1
   2
     5
   4   7
  3   6
*/

/*
 1
  2
    6
   4 7
  3
*/

/*
 1
  2
    6
   3 7
*/