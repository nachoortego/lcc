#include "cdlist.h"
#include <stdlib.h>

CDList cdlist_crear() {
  return NULL;
}

void cdlist_destruir(CDList lista) {
  lista->ant->sig = NULL;
  DNodo *nodoAEliminar;
  while (lista != NULL) {
    nodoAEliminar = lista;
    lista = lista->sig;
    free(nodoAEliminar);
  }
}

int cdlist_vacia(CDList lista) {
  return lista == NULL;
}

CDList cdlist_agregar_final(CDList lista, int dato) {
  DNodo *nuevoNodo = malloc(sizeof(DNodo));
  nuevoNodo->dato = dato;

  if (cdlist_vacia(lista)){
    nuevoNodo->ant = nuevoNodo->sig = nuevoNodo;
    lista = nuevoNodo;
  }
  else {
    lista->ant->sig = nuevoNodo;
    nuevoNodo->ant = lista->ant;
    lista->ant = nuevoNodo;
    nuevoNodo->sig = lista;
  }
  return lista;
}

CDList cdlist_agregar_inicio(CDList lista, int dato) {
  lista = cdlist_agregar_final(lista, dato);
  return lista->ant;
}

void cdlist_recorrer(CDList lista, FuncionVisitante visit, DListOrdenDeRecorrido orden) {
  if (orden == DLIST_RECORRIDO_HACIA_ADELANTE){
    visit(lista->dato);
    for (DNodo *nodo = lista->sig; nodo != lista; nodo = nodo->sig)
        visit(nodo->dato);
  }
  else{
    DNodo* final = lista->ant;
    visit(final->dato);
    for (DNodo *nodo = final->ant; nodo != final; nodo = nodo->ant)
        visit(nodo->dato);
  }
  
}

