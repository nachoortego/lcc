#include "heap.h"
#include <stdlib.h>
#include <stdio.h>

static int comparar_entero(void *dato1, void *dato2) {
  int num1 = *((int *)dato1);
  int num2 = *((int *)dato2);
  return num1 - num2;
}

static void imprimir_entero(void *dato) {
  printf("%d ", *((int *)dato));
}

int main() {
  BHeap heap = bheap_crear(5,comparar_entero);
  printf("Vacio? %d\n",bheap_es_vacio(heap));

  int arr[7] = {1, 2, 5, 7, 4, 3, 6};
  for (int i = 0; i < 7; i++)
    heap = bheap_insertar(heap, &arr[i]);

  printf("Vacio? %d\n",bheap_es_vacio(heap));
  bheap_recorrer(heap, imprimir_entero);
  puts("");
  bheap_destruir(heap);


  return 0;
}