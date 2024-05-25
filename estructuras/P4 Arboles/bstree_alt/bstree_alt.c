#include "bstree_alt.h"
#include <assert.h>
#include <stdlib.h>

/**
 * Implementacion alternativa para arboles de busqueda binaria.
 * Se mantienen dos niveles de abstraccion:
 * El nivel inferior implementa ABB con datos de tipo void*.
 * El nivel superior encapsula el ABB y las funciones que copian,
 * destruyen y comparan los datos.
 * El nivel superior es con quien se comunica el usuario y se encarga de
 * llamar a las funciones del nivel inferior con los parametros apropiados.
 */

/**
 * Nivel inferior:
 * ===============
 */

/**
 * Estructura del nodo del arbol de busqueda binaria.
 * Tiene un puntero al dato (dato),
 * un puntero al nodo raiz del subarbol izquierdo (izq),
 * y un puntero al nodo raiz del subarbol derecho (der).
 */
typedef struct _BST_Nodo {
  void *dato;
  struct _BST_Nodo *izq, *der;
} BST_Nodo;

/**
 * A continuacion, se implementan las funciones del nivel inferior.
 * Las mismas se declaran como static, es decir, solo pueden ser llamadas desde
 * este modulo. De esta forma, se impide al usuario llamarlas directamente, sin
 * pasar por el nivel superior.
 */

static void bstree_nodo_destruir(BST_Nodo *raiz, FuncionDestructora destr) {
  if (raiz != NULL) {
    bstree_nodo_destruir(raiz->izq, destr);
    bstree_nodo_destruir(raiz->der, destr);
    destr(raiz->dato);
    free(raiz);
  }
};

static int bstree_nodo_buscar(BST_Nodo *raiz, void *dato,
                              FuncionComparadora comp) {
  if (raiz == NULL)
    return 0;
  else if (comp(dato, raiz->dato) == 0) // raiz->dato == dato
    return 1;
  else if (comp(dato, raiz->dato) < 0) // dato < raiz->dato
    return bstree_nodo_buscar(raiz->izq, dato, comp);
  else // raiz->dato < dato
    return bstree_nodo_buscar(raiz->der, dato, comp);
}

static BST_Nodo *bstree_nodo_insertar(BST_Nodo *raiz, void *dato,
                                      FuncionCopiadora copia,
                                      FuncionComparadora comp) {
  if (raiz == NULL) { // insertar el dato en un nuevo nodo
    BST_Nodo *nuevoNodo = malloc(sizeof(struct _BST_Nodo));
    assert(nuevoNodo != NULL);
    nuevoNodo->dato = copia(dato);
    nuevoNodo->izq = nuevoNodo->der = NULL;
    return nuevoNodo;
  } else if (comp(dato, raiz->dato) < 0) // dato < raiz->dato
    raiz->izq = bstree_nodo_insertar(raiz->izq, dato, copia, comp);
  else if (comp(dato, raiz->dato) > 0) // raiz->dato < dato
    raiz->der = bstree_nodo_insertar(raiz->der, dato, copia, comp);
  // si el dato ya se encontraba, no es insertado
  return raiz;
}

static void bstree_nodo_recorrer(BST_Nodo *raiz, BSTreeRecorrido orden,
                                 FuncionVisitanteExtra visita, void *extra) {
  if (raiz != NULL) {
    if (orden == BTREE_RECORRIDO_PRE)
      visita(raiz->dato, extra);
    bstree_nodo_recorrer(raiz->izq, orden, visita, extra);
    if (orden == BTREE_RECORRIDO_IN)
      visita(raiz->dato, extra);
    bstree_nodo_recorrer(raiz->der, orden, visita, extra);
    if (orden == BTREE_RECORRIDO_POST)
      visita(raiz->dato, extra);
  }
}

/**
 * Nivel superior:
 * ===============
 */

/**
 * Estructura del arbol de busqueda binaria.
 * Tiene un puntero al nodo raiz (raiz),
 * un puntero a funcion (copia) que recibe un dato y retorna un puntero con la
 * direccion de memoria de una copia fisica del dato,
 * un puntero a funcion (comp) que compara dos datos y retorna un entero
 * negativo si el primero es menor que el segundo, 0 si son iguales, y un entero
 * positivo en caso contrario,
 * y un puntero a una funcion (destr) que recibe un dato y lo destruye.
 */
struct _BSTree {
  BST_Nodo *raiz;
  FuncionCopiadora copia;
  FuncionComparadora comp;
  FuncionDestructora destr;
};

/**
 * Retorna un arbol de busqueda binaria vacio.
 * Por unica vez se piden por parametro los punteros a funcion.
 */
BSTree bstee_crear(FuncionCopiadora copia, FuncionComparadora comp,
                   FuncionDestructora destr) {
  BSTree arbol = malloc(sizeof(struct _BSTree));
  assert(arbol != NULL);
  arbol->raiz = NULL;
  arbol->copia = copia;
  arbol->comp = comp;
  arbol->destr = destr;
  return arbol;
}

/**
 * bstree_destruir: Destruye el arbol y sus datos
 */
void bstree_destruir(BSTree arbol) {
  bstree_nodo_destruir(arbol->raiz, arbol->destr);
  free(arbol);
}

/**
 * bstree_buscar: Retorna 1 si el dato se encuentra y 0 en caso
 * contrario
 */
int bstree_buscar(BSTree arbol, void *dato) {
  return bstree_nodo_buscar(arbol->raiz, dato, arbol->comp);
}

/**
 * bstree_insertar: Inserta un dato no repetido en el arbol, manteniendo la
 * propiedad del arbol de busqueda binaria
 */
void bstree_insertar(BSTree arbol, void *dato) {
  arbol->raiz =
      bstree_nodo_insertar(arbol->raiz, dato, arbol->copia, arbol->comp);
}

/**
 * bstree_recorrer: Recorrido DSF del arbol
 */
void bstree_recorrer(BSTree arbol, BSTreeRecorrido orden,
                     FuncionVisitanteExtra visita, void *extra) {
  bstree_nodo_recorrer(arbol->raiz, orden, visita, extra);
}
