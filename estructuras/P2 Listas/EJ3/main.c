#include <stdio.h>
#include <stdlib.h>

typedef void (*FuncionVisitante) (int dato);

typedef struct _SNodo {
int dato;
struct _SNodo *sig;
} SNodo;

typedef struct SList {
SNodo *primero;
SNodo *ultimo;
} SList;

SList* slist_crear() { 
    SList* lista = malloc(sizeof(SList));
    lista->primero = NULL;
    lista->ultimo = NULL;
    return lista; }

SList* slist_agregar_inicio(SList* lista, int dato) {
    SNodo* nuevoNodo = malloc(sizeof(SNodo));
    nuevoNodo->dato = dato;
    nuevoNodo->sig = lista->primero;
    if(lista->ultimo == NULL) {
        lista->ultimo = nuevoNodo;
    }
    lista->primero = nuevoNodo;
    return lista;
}

SList* slist_agregar_final(SList* lista, int dato) {
    SNodo* nuevoNodo = malloc(sizeof(SNodo));
    nuevoNodo->dato = dato;
    nuevoNodo->sig = NULL;

    if(lista->ultimo != NULL)
        lista->ultimo->sig = nuevoNodo;
    if(lista->primero == NULL)
        lista->primero = nuevoNodo;
    
    lista->ultimo = nuevoNodo;

    return lista;
}

void slist_recorrer(SList* lista, FuncionVisitante visit) {
  for (SNodo* nodo = lista->primero; nodo != NULL; nodo = nodo->sig)
    visit(nodo->dato);
}

static void imprimir_entero(int dato) {
  printf("%d ", dato);
}


int main() {
    SList* lista = slist_crear();
    slist_recorrer(lista,imprimir_entero);
    slist_agregar_final(lista,5);
    slist_agregar_final(lista,6);
    slist_agregar_final(lista,7);
    slist_agregar_inicio(lista,10);
    slist_recorrer(lista,imprimir_entero);
    return 0;
}