#include "heap.h"
#include <stdlib.h>
#include <stdio.h>

int left(int nodo){
  return 2*nodo;
}

int right(int nodo){
  return 2*nodo + 1;
}

int father(int nodo){
  return (nodo - 1) / 2;
}

BHeap bheap_crear(int capacidad, FuncionComparadora comp){
  BHeap heap = malloc(sizeof(struct _BHeap));
  heap->arr = malloc(sizeof(void *) * capacidad);
  heap->capacidad = capacidad;
  heap->ultimo = -1;
  heap->comp = comp;
  
  return heap;
}

void bheap_destruir(BHeap heap){
  free(heap->arr);
  free(heap);
}

int bheap_es_vacio(BHeap heap){
  return heap->ultimo == -1;
}

void bheap_recorrer(BHeap heap, FuncionVisitante visit){
  for(int i = 0; i < heap->ultimo; i++)
   visit(heap->arr[i]);
}

BHeap bheap_insertar(BHeap heap, void* dato){
  // Realoco el arreglo si no hay memoria
  if(heap->ultimo + 1 == heap->capacidad) {
    heap->capacidad *= 2;
    heap->arr = realloc(heap->arr, sizeof(void *) * heap->capacidad);
  }
  // Agrego el elemento al final del array
  heap->ultimo++;
  heap->arr[heap->ultimo] = dato;
  int nodo = heap->ultimo;
  for(; heap->ultimo > 0 && heap->comp(heap->arr[nodo], heap->arr[father(nodo)]) > 0; nodo = father(nodo)) {
    void* temp = heap->arr[nodo];
    heap->arr[nodo] = heap->arr[father(nodo)];
    heap->arr[father(nodo)] = temp;
  }

  return heap;
}