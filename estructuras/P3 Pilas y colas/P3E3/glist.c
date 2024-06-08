#include "glist.h"
#include "pila.h"
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

/**
 * Devuelve una lista vacía.
 */
GList glist_crear() { 
  GList lista = malloc(sizeof(struct _GList));
  lista->first = NULL;
  lista->last = NULL;
  return lista;
}

/**
 * Destruccion de la lista.
 */
void glist_destruir_node(GNode* node, FuncionDestructora destroy) {
  GNode *nodeToDelete;
  while (node != NULL) {
    nodeToDelete = node;
    node = node->next;
    destroy(nodeToDelete->data); 
    free(nodeToDelete);
  }
}

void glist_destruir(GList list, FuncionDestructora destroy) {
  glist_destruir_node(list->first, destroy);
  free(list);
}

/**
 * Determina si la lista es vacía.
 */
int glist_vacia(GList list) { 
  return (list->first == NULL); 
}

/**
 * Agrega un elemento al inicio de la lista.
 */
void glist_agregar_inicio(GList list, void *data, FuncionCopia copy) {
  GNode *newNode = malloc(sizeof(GNode));
  assert(newNode != NULL);
  newNode->next = list->first;
  list->first = newNode;
  newNode->data = copy(data);
}

void glist_agregar_final (GList list, void* data, FuncionCopia copy) {
  GNode *newNode = malloc(sizeof(GNode));
  assert(newNode != NULL);
  newNode->next = NULL;
  if (list->last) list->last->next = newNode;
  else list->first = newNode;
  list->last = newNode;
  newNode->data = copy(data);
}

/**
 * Busca un elemento en la lista.
 */
int glist_buscar(GList list, void* data, FuncionComparar comp){
  int found = 0;
  for(GNode *node = list->first; found == 0 && node != NULL; node = node->next)
    if (comp(node->data, data) == 0) found = 1;
  return found;
}

/**
 * Recorrido de la lista, utilizando la funcion pasada.
 */
void glist_recorrer(GList list, FuncionVisitante visit) {
  for (GNode *node = list->first; node != NULL; node = node->next)
    visit(node->data);
}

/**
 * Funciones auxiliares
*/
void* no_copia (void* dato) {
    return dato;
}

void no_destruir (void* dato) {
    return;
}

/**
 * Da vuelta el orden de la lista.
*/
void glist_revertir(GList lista) {
    Pila p = pila_crear();
    for (GNode* nodo = lista->first; nodo != NULL; nodo = nodo->next){
        p = pila_apilar(p, nodo->data, no_copia);
    }
    glist_destruir_node(lista->first, no_destruir);
    lista->first = NULL;
    lista->last = NULL;
    while (!pila_vacia(p)){
        glist_agregar_final(lista, pila_tope(p), no_copia);
        p = pila_desapilar(p, no_destruir);
    }
    pila_destruir(p, no_destruir);
}

void glist_revertir_mejorado (GList lista) {
  if (glist_vacia(lista)) return;

  Pila p = pila_crear();
  for (GNode* nodo = lista->first; nodo != NULL; nodo = nodo->next)
    p = pila_apilar(p, nodo, no_copia);

  GNode* nodo = pila_tope(p);
  lista->first = nodo;
  pila_desapilar(p, no_destruir);
  while (!pila_vacia(p)){
    nodo->next = pila_tope(p);
    pila_desapilar(p, no_destruir);
    nodo = nodo->next;
  }
  nodo->next = NULL;
  lista->last = nodo;
}


