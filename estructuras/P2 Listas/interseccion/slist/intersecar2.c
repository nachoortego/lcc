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
  for (SList nodo1 = list1; nodo1 != NULL; nodo1 = nodo1->sig) {
    if (!slist_contiene(nodo1->sig, nodo1->dato, cmp) && slist_contiene(list2, nodo1->dato, cmp)) {
      inter = slist_agregar_inicio(inter, nodo1->dato);
    }
  }
  return inter;
}
