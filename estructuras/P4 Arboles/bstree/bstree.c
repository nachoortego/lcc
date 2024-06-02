#include "bstree.h"
#include <assert.h>
#include <stdlib.h>

/**
 * Estructura del nodo del arbol de busqueda binaria.
 * Tiene un puntero al dato (dato),
 * un puntero al nodo raiz del subarbol izquierdo (izq),
 * y un puntero al nodo raiz del subarbol derecho (der).
 */
struct _BST_Nodo {
  void *dato;
  struct _BST_Nodo *izq, *der;
};

/**
 * bstee_crear: Retorna un arbol de busqueda binaria vacio
 */
BSTree bstee_crear() { return NULL; }

/**
 * bstree_destruir: Destruye el arbol y sus datos
 */
void bstree_destruir(BSTree raiz, FuncionDestructora destr) {
  if (raiz != NULL) {
    bstree_destruir(raiz->izq, destr);
    bstree_destruir(raiz->der, destr);
    destr(raiz->dato);
    free(raiz);
  }
};

/**
 * bstree_buscar: Retorna 1 si el dato se encuentra y 0 en caso
 * contrario
 */
int bstree_buscar(BSTree raiz, void *dato, FuncionComparadora comp) {
  if (raiz == NULL)
    return 0;
  else if (comp(dato, raiz->dato) == 0) // raiz->dato == dato
    return 1;
  else if (comp(dato, raiz->dato) < 0) // dato < raiz->dato
    return bstree_buscar(raiz->izq, dato, comp);
  else // raiz->dato < dato
    return bstree_buscar(raiz->der, dato, comp);
}

/**
 * bstree_insertar: Inserta un dato no repetido en el arbol, manteniendo la
 * propiedad del arbol de busqueda binaria
 */
BSTree bstree_insertar(BSTree raiz, void *dato, FuncionCopiadora copia,
                       FuncionComparadora comp) {
  if (raiz == NULL) { // insertar el dato en un nuevo nodo
    struct _BST_Nodo *nuevoNodo = malloc(sizeof(struct _BST_Nodo));
    assert(nuevoNodo != NULL);
    nuevoNodo->dato = copia(dato);
    nuevoNodo->izq = nuevoNodo->der = NULL;
    return nuevoNodo;
  } else if (comp(dato, raiz->dato) < 0) // dato < raiz->dato
    raiz->izq = bstree_insertar(raiz->izq, dato, copia, comp);
  else if (comp(dato, raiz->dato) > 0) // raiz->dato < dato
    raiz->der = bstree_insertar(raiz->der, dato, copia, comp);
  // si el dato ya se encontraba, no es insertado
  return raiz;
}

/**
 * bstree_recorrer: Recorrido DSF del arbol
 */
void bstree_recorrer(BSTree raiz, BSTreeRecorrido orden,
                     FuncionVisitanteExtra visita, void *extra) {
  if (raiz != NULL) {
    if (orden == BTREE_RECORRIDO_PRE)
      visita(raiz->dato, extra);
    bstree_recorrer(raiz->izq, orden, visita, extra);
    if (orden == BTREE_RECORRIDO_IN)
      visita(raiz->dato, extra);
    bstree_recorrer(raiz->der, orden, visita, extra);
    if (orden == BTREE_RECORRIDO_POST)
      visita(raiz->dato, extra);
  }
}

/**
 * Elimina un nodo del arbol
 */
BSTree bstree_eliminar(BSTree raiz, void *dato, FuncionComparadora comp, FuncionDestructora destr) {
  if(raiz == NULL)
    return NULL;
  if(comp(raiz->dato, dato) == 0) {
    BSTree succ = raiz->der;
    if(raiz->izq == NULL){
      destr(raiz->dato);
      free(raiz);
      return succ;
    }
    if(raiz->der == NULL){
      succ = raiz->izq;
      destr(raiz->dato);
      free(raiz);
      return succ;
    }
    //Smallest in right subtree
    BSTree succParent = raiz;
    while (succ->izq != NULL) {
      succParent = succ;
      succ = succ->izq;
    }
    destr(raiz->dato);
    raiz->dato = succ->dato;
    if (succParent->izq == succ)
      succParent->izq = succ->der;
    else
      succParent->der = succ->der;
    free(succ);
  }
  else if(comp(raiz->dato,dato) > 0)
    raiz->izq = bstree_eliminar(raiz->izq, dato, comp, destr);
  else //if(comp(raiz->dato,dato) < 0)
    raiz->der = bstree_eliminar(raiz->der, dato, comp, destr);

  return raiz;
}

/*
 1
   2
     5
   4   7
  3   6
        n
       n n
*/

void no_hacer_nada(void* dato) {
}
BSTree bstree_eliminar_balta(BSTree raiz, void *dato, FuncionComparadora comp, FuncionDestructora destr) {
  //printf("Dato a eliinar: %d", *((int *)dato));
  if(raiz == NULL)
    return NULL;
  if(comp(raiz->dato, dato) == 0) {
    BSTree succ = raiz->der;
    if(raiz->izq == NULL){
      destr(raiz->dato);
      free(raiz);
      return succ;
    }
    if(raiz->der == NULL){
      succ = raiz->izq;
      destr(raiz->dato);
      free(raiz);
      return succ;
    }
    //Smallest in right subtree
    BSTree rightNode = raiz->der;
    while (succ->izq != NULL) 
      succ = succ->izq;
    destr(raiz->dato);
    raiz->dato = succ->dato;
    raiz->der = bstree_eliminar_balta(rightNode, succ->dato, comp, no_hacer_nada);
  }
  else if(comp(raiz->dato,dato) > 0)
    raiz->izq = bstree_eliminar_balta(raiz->izq, dato, comp, destr);
  else //if(comp(raiz->dato,dato) < 0)
    raiz->der = bstree_eliminar_balta(raiz->der, dato, comp, destr);

  return raiz;
}

/*
 1
  2
    6
   3  7

*/

struct k_esimo {
  int count;
  void* dato;
};

void k_esimo_visita(void* dato, void* extra) {
  struct k_esimo* extra_data = (struct k_esimo*)extra;
  if (extra_data->count == 1){
    extra_data->dato = dato;
    extra_data->count = -1;
  }
  else 
    extra_data->count = extra_data->count - 1;
}

BSTree bstree_k_esimo_menor(BSTree raiz, int k) {
  struct k_esimo extra;
  extra.count = k;
  extra.dato = NULL;
  bstree_recorrer(raiz,BTREE_RECORRIDO_IN,k_esimo_visita,&extra);
  return extra.dato;
}

BSTree bstree_validar_aux(BSTree raiz, FuncionComparadora comp, void* anterior, int* validar){
  bstree_validar_aux(raiz->izq, comp, anterior, validar);
  if(raiz == NULL)
    return NULL;
  if(comp(anterior,raiz->dato) > 0){
    *validar = 0;
  }
  anterior = raiz->dato;
  bstree_validar_aux(raiz->der, comp, anterior, validar);
}

int bstree_validar(BSTree raiz, FuncionComparadora comp){
  int validacion = 1;
  bstree_validar_aux(raiz, comp, NULL, &validacion);
  return validacion;
}