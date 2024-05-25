#include "btree.h"
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

struct _BTNodo {
  int dato;
  struct _BTNodo *left;
  struct _BTNodo *right;
};

/**
 * Devuelve un arbol vacío.
 */
BTree btree_crear() { return NULL; }

/**
 * Destruccion del árbol.
 */
void btree_destruir(BTree nodo) {
  if (nodo != NULL) {
    btree_destruir(nodo->left);
    btree_destruir(nodo->right);
    free(nodo);
  }
}

/**
 * Indica si el árbol es vacío.
 */
int btree_empty(BTree nodo) { return nodo == NULL; }

/**
 * Crea un nuevo arbol, con el dato dado en el nodo raiz, y los subarboles dados
 * a izquierda y derecha.
 */
BTree btree_unir(int dato, BTree left, BTree right) {
  BTree nuevoNodo = malloc(sizeof(struct _BTNodo));
  assert(nuevoNodo != NULL);
  nuevoNodo->dato = dato;
  nuevoNodo->left = left;
  nuevoNodo->right = right;
  return nuevoNodo;
}

/**
 * Recorrido del arbol, utilizando la funcion pasada.
 */
void btree_recorrer(BTree arbol, BTreeOrdenDeRecorrido orden,
                    FuncionVisitante visit) {
  if(arbol != NULL)
    switch (orden) {
      case BTREE_RECORRIDO_PRE:
        visit(arbol->dato);
        btree_recorrer(arbol->left, orden, visit);
        btree_recorrer(arbol->right, orden, visit);
        break;
      case BTREE_RECORRIDO_IN:
        btree_recorrer(arbol->left, orden, visit);
        visit(arbol->dato);
        btree_recorrer(arbol->right, orden, visit);
        break;
      case BTREE_RECORRIDO_POST:
        btree_recorrer(arbol->left, orden, visit);
        btree_recorrer(arbol->right, orden, visit);
        visit(arbol->dato);
        break;
      }
}

int btree_nnodos(BTree arbol) {
  if(arbol == NULL) return 0;
  return 1 + btree_nnodos(arbol->left) + btree_nnodos(arbol->right);
}

int btree_buscar(BTree arbol, int dato) {
  if(arbol == NULL) return 0;
  int sum = (arbol->dato == dato) + btree_buscar(arbol->left, dato) + btree_buscar(arbol->right, dato);
  return sum > 0;
}

BTree btree_copiar(BTree arbol) {
  if(arbol == NULL) return btree_crear();
  return btree_unir(arbol->dato, btree_copiar(arbol->left), btree_copiar(arbol->right));
}

int btree_altura(BTree arbol){
  if(arbol == NULL) return 0;
  int left = 1 + btree_altura(arbol->left);
  int right = 1 + btree_altura(arbol->right);

  if(left > right) return left;
  return right;
}

int btree_nnodos_profundidad(BTree arbol, int prof){
  if (arbol == NULL) return 0; // vacio
  if(prof == 0) // solo raiz
    return 1;
  int cant = 0;
  if(prof == 1){ // cuento hijos de prof-1
    if (arbol->left != NULL) cant++;
    if (arbol->right != NULL) cant++;
    return cant;
  }
  return cant + btree_nnodos_profundidad(arbol->left, prof - 1) + btree_nnodos_profundidad(arbol->right, prof - 1);
}

int btree_sumar(BTree arbol) {
  if(arbol == NULL) return 0;
  return arbol->dato + btree_sumar(arbol->left) + btree_sumar(arbol->right);
}

void btree_recorrer_extra(BTree arbol, BTreeOrdenDeRecorrido orden, FuncionVisitanteExtra visit, void *extra){
    if(arbol != NULL)
    switch (orden) {
      case BTREE_RECORRIDO_PRE:
        visit(arbol->dato, extra);
        btree_recorrer_extra(arbol->left, orden, visit, extra);
        btree_recorrer_extra(arbol->right, orden, visit, extra);
        break;
      case BTREE_RECORRIDO_IN:
        btree_recorrer_extra(arbol->left, orden, visit, extra);
        visit(arbol->dato, extra);
        btree_recorrer_extra(arbol->right, orden, visit, extra);
        break;
      case BTREE_RECORRIDO_POST:
        btree_recorrer_extra(arbol->left, orden, visit, extra);
        btree_recorrer_extra(arbol->right, orden, visit, extra);
        visit(arbol->dato, extra);
        break;
      }
}

void btree_recorrer_por_profundidad(BTree arbol, FuncionVisitante visit, int prof) {
  if(prof == 0){
    visit(arbol->dato);
    return;
  }
  if(prof == 1) {
    if(arbol->left != NULL)
      visit(arbol->left->dato);
    if(arbol->right != NULL)
      visit(arbol->right->dato);
    return;
  }
  btree_recorrer_por_profundidad(arbol->left, visit, prof-1);
  btree_recorrer_por_profundidad(arbol->right, visit, prof-1);
}

void btree_recorrer_bfs(BTree arbol, FuncionVisitante visit) {
  if(arbol != NULL){
    int altura = btree_altura(arbol);
    for(int p = 0; p < altura; p++)
      btree_recorrer_por_profundidad(arbol, visit, p);
  }  
}
