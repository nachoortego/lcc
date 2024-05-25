#include "sglist.h"
#include <stdlib.h>
#include <stdio.h>

// Retorna una lista ordenada vacia.
SGList sglist_crear() { return NULL; }

// Destruye una lista ordenada.
void sglist_destruir(SGList list, FuncionDestructora destroy) {
    GNode *nodeToDelete;
    while (list != NULL) {
        nodeToDelete = list;
        list = list->next;
        destroy(nodeToDelete->data);
        free(nodeToDelete);
    }
}

// Determina si una lista ordenada es vacia.
int sglist_vacia(SGList list) { return (list == NULL); }

// Aplica la funcion visitante a cada elemento de la lista ordenada.
void sglist_recorrer(SGList list, FuncionVisitante visit) {
    for(GNode *temp = list; temp!=NULL; temp = temp->next) {
        visit(temp->data);
    }
}

// Inserta un nuevo dato en la lista ordenada. La funcion de comparacion es la que determina el criterio
// de ordenacion, su tipo esta declarado como typedef int (*FuncionComparadora)(void *, void*), y
// retorna un entero negativo si el primer argumento es menor que el segundo, 0 si son iguales,y un entero positivo en caso contrario.
SGList sglist_insertar(SGList list, void* data, FuncionCopia copy, FuncionComparadora compare) {
    GNode* nuevoNodo = malloc(sizeof(GNode));
    nuevoNodo->data = copy(data);
    if (list == NULL){
            nuevoNodo->next = NULL;
            return nuevoNodo;
        }
    GNode *node = list;
    for (;node->next != NULL || (compare(node->data, data) >= 0); node = node->next);
    GNode* temp = node->next;
    node->next = nuevoNodo;
    nuevoNodo->next = temp;

    return list;
}

SGList sglist_insertarR(SGList list, void* data, FuncionCopia copy, FuncionComparadora compare) {
  if(list == NULL || compare(list->data, data) >= 0) {
    GNode* nuevoNodo = malloc(sizeof(GNode));
    nuevoNodo->data = data;
    nuevoNodo->next = list;
    return nuevoNodo;
  }
  list->next = sglist_insertarR(list->next,data,copy,compare);
  return list;
}

int sglist_buscar(GList list, void * data, FuncionComparadora compare) {
    int resultado = compare(data,list->data);
    if(resultado  < 0) {
        printf("NO BUSCA, resultado = %d", resultado);
        return 0;
    }
    int i = 0;
    for(GNode* nodo = list; nodo != NULL && (resultado = compare(data, nodo->data)) > 0; nodo = nodo->next) {
        printf("COMPARA CON %d, resultado = %d\n", i, resultado);
        i++;
        if(resultado == 0)
            return 1;
    }
    return 0;
}

SGList sglist_arr(void** array, int n, FuncionCopia copy, FuncionComparadora compare) {
    SGList list = malloc(sizeof(SGList));
    for(int i = 0; i < n; i++)
        sglist_insertarR(list, array[i], copy, compare);
    return list;
    }