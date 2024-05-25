#include "slist.h"
#include "intersecar.h"

int slist_contiene(SList list, int dato, FuncionComparadora cmp) {
  for (SList nodo = list; nodo != NULL; nodo = nodo->sig) {
    if (cmp(nodo->dato, dato) == 0) {
      return 1;
    }
  }
  return 0;
}

SList slist_intersecar_custom(SList list1, SList list2, FuncionComparadora cmp) {
  SList inter = slist_crear();
  int bandera;
  for (SList nodo1 = list1; nodo1 != NULL; nodo1 = nodo1->sig) {
    if (!slist_contiene(list1->sig, list1->dato, cmp)) {
      bandera = 1;
      for (SList nodo2 = list2; nodo2 != NULL && bandera; nodo2 = nodo2->sig) {
        if (cmp(nodo1->dato, nodo2->dato) == 0) {
          inter = slist_agregar_inicio(inter, nodo1->dato);
          bandera = 0; // Ya encontramos uno igual en la segunda lista, podemos dejar de iterarla
        }
      }
    }
  }
  return inter;
}

