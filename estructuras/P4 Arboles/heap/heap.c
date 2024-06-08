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
  return nodo / 2;
}

BHeap bheap_crear(int capacidad, FuncionComparadora comp){
  BHeap heap = malloc(sizeof(struct _BHeap));
  heap->arr = malloc(sizeof(void *) * capacidad);
  heap->arr[0] = NULL;
  heap->capacidad = capacidad;
  heap->ultimo = 0;
  heap->comp = comp;
  
  return heap;
}

void bheap_destruir(BHeap heap){
  free(heap->arr);
  free(heap);
}

int bheap_es_vacio(BHeap heap){
  return heap->ultimo == 0;
}

void bheap_recorrer(BHeap heap, FuncionVisitante visit){
  for(int i = 1; i < heap->ultimo; i++){
    visit(heap->arr[i]);
  }
}

BHeap bheap_insertar(BHeap heap, void* dato) {
  // Realoco el arreglo si no hay memoria
  if (heap->ultimo == heap->capacidad - 1) {
    heap->capacidad *= 2;
    heap->arr = realloc(heap->arr, sizeof(void *) * heap->capacidad);
  }
  // Agrego el elemento al final del array
  heap->ultimo++;
  heap->arr[heap->ultimo] = dato;
  // Hago flotar el nuevo nodo
  int nodo = heap->ultimo;
  for (;nodo > 1 && heap->comp(heap->arr[nodo], heap->arr[father(nodo)]) > 0; nodo = father(nodo)) {
    void* temp = heap->arr[nodo];
    heap->arr[nodo] = heap->arr[father(nodo)];
    heap->arr[father(nodo)] = temp;
  }

  return heap;
}


BHeap bheap_eliminar(BHeap heap, int index) {
  int esMayor = 1;
  int hijoMayor;

  // Mover el último nodo al índice del nodo a eliminar
  heap->arr[index] = heap->arr[heap->ultimo-1];
  heap->ultimo--; // Reducir el tamaño del heap

  int nodo = index;
  while (left(nodo) <= heap->ultimo && esMayor) { // Mientras tenga al menos un hijo
    hijoMayor = left(nodo); // Hijo izquierdo por defecto

    if (right(nodo) <= heap->ultimo && heap->comp(heap->arr[right(nodo)], heap->arr[left(nodo)]) > 0)
      hijoMayor = right(nodo); // Si el derecho existe y es mayor, seleccionarlo

    if (heap->comp(heap->arr[nodo], heap->arr[hijoMayor]) >= 0) 
      esMayor = 0; // Si el nodo es mayor o igual que ambos hijos, detener

    else {
      // Intercambiar nodo con el hijo mayor
      void* temp = heap->arr[nodo];
      heap->arr[nodo] = heap->arr[hijoMayor];
      heap->arr[hijoMayor] = temp;
      nodo = hijoMayor; // Continuar con el hijo mayor
    }
  }

  return heap;
}

