#include "heap.h"
#include <stdlib.h>
#include <stdio.h>

typedef BHeap ColaP;

ColaP cola_prioridad_crear(int capacidad, FuncionComparadora comp) {
  return bheap_crear(capacidad, comp);
}

void cola_prioridad_destruir(ColaP cola) {
  bheap_destruir(cola);
}

int cola_prioridad_es_vacia(ColaP cola) {
  return bheap_es_vacio(cola);
}

void* cola_prioridad_maximo(ColaP cola) {
  return cola->ultimo > 0 ? cola->arr[1] : NULL;
}

void* cola_prioridad_eliminar_maximo(ColaP cola) {
  return bheap_eliminar(cola, 1);
}

ColaP cola_prioridad_insertar(ColaP cola, void* dato) {
  return bheap_insertar(cola, dato);
}