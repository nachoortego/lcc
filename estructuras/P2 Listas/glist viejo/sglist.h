#ifndef __SLIST_H__
#define __SGLIST_H__
#include "glist.h"

typedef GList SGList;
typedef int (*FuncionComparadora)(void *, void *);

// Retorna una lista ordenada vacia.
SGList sglist_crear(); 

// Destruye una lista ordenada.
void sglist_destruir(SGList, FuncionDestructora);

// Determina si una lista ordenada es vacia.
int sglist_vacia(SGList);

// Aplica la funcion visitante a cada elemento de la lista ordenada.
void sglist_recorrer(GList, FuncionVisitante);

// Inserta un nuevo dato en la lista ordenada. La funcion de comparacion es la que determina el criterio
// de ordenacion, su tipo esta declarado como typedef int (*FuncionComparadora)(void *, void*), y
// retorna un entero negativo si el primer argumento es menor que el segundo, 0 si son iguales,y un entero positivo en caso contrario.
SGList sglist_insertar(SGList, void *, FuncionCopia, FuncionComparadora);

// Lo mismo pero recursivo
SGList sglist_insertarR(SGList, void *, FuncionCopia, FuncionComparadora);

// Busca un dato en la lista ordenada, retornando 1 si lo encuentra y 0 en caso contrario (aprovechar que la lista esta ordenada para
// hacer esta busqueda mas eficiente).
int sglist_buscar(GList, void *, FuncionComparadora);

// Que construye una lista ordenada a partir de un arreglo de elementos y su longitud.
SGList sglist_arr(void **, int, FuncionCopia, FuncionComparadora);

#endif /* __SGLIST_H__ */
