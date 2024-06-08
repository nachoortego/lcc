#ifndef __GLIST_H__
#define __GLIST_H__

#include "tipos.h"

typedef struct _GNode {
  void *data;
  struct _GNode *next;
} GNode;

typedef struct _GList {
  GNode* first;
  GNode* last;
} *GList;

/**
 * Devuelve una lista vacía.
 */
GList glist_crear();

/**
 * Destruccion de la lista.
 */
void glist_destruir(GList list, FuncionDestructora);

/**
 * Determina si la lista es vacía.
 */
int glist_vacia(GList list);

/**
 * Agrega un elemento al inicio de la lista.
 */
void glist_agregar_inicio(GList list, void *data, FuncionCopia);

/**
 * Agrega un elemento al final de la lista.
 */
void glist_agregar_final (GList list, void* data, FuncionCopia copy);

/**
 * Busca un elemento en la lista.
 */
int glist_buscar(GList list, void* data, FuncionComparar);


/**
 * Recorrido de la lista, utilizando la funcion pasada.
 */
void glist_recorrer(GList list, FuncionVisitante visit);

/**
 * Da vuelta el orden de la lista.
*/
void glist_revertir (GList lista);
void glist_revertir_mejorado (GList lista);

#endif /* __GLIST_H__ */
