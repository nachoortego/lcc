#include <stdlib.h>
#include <stdio.h>
#include "contacto.h"
#include "glist.h"

typedef GList Pila;

Pila pila_crear() {
    Pila nuevaPila = glist_crear();
    return nuevaPila;
}

void pila_destruir(Pila pila, FuncionDestructora destroy) {
    glist_destruir(pila, destroy);
}

int pila_es_vacia(Pila pila) {
    return glist_vacia(pila);
}

void* pila_tope(Pila pila) {
    return pila->data;
}

void pila_apilar(Pila pila, void* dato, FuncionCopia copy) {
    glist_agregar_inicio(pila,dato,copy);
}

void pila_desapilar(Pila pila, FuncionDestructora destroy) {
    GNode* aux = pila->next;
    destroy(pila->data);
    free(pila);
    return aux;
}

void pila_imprimir(Pila pila, FuncionVisitante visit) {
    glist_recorrer(pila, visit);
}

GList revertir_lista(GList list, FuncionCopia copy, FuncionDestructora destroy) {
    Pila pila = pila_crear();
    for(GNode* temp = list; temp != NULL; temp = temp->next)
        pila_apilar(pila, temp->data, copy);
    glist_destruir(list, destroy);
    return pila;
}

int main() {

}