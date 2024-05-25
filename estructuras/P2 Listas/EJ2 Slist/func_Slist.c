#include <stdio.h>
#include <stdlib.h>

typedef struct _Snodo {
    int dato;
    struct _Snodo *sig;
} SNodo;

void mostrar_lista(SNodo *lista) {
    for(SNodo* temp=lista; temp != NULL ; temp=temp->sig) {
        printf("%d ", temp->dato);
    }
    printf("\n");
}

void slist_agregar_inicio(SNodo **lista, int dato) {
    SNodo* nuevoNodo = malloc(sizeof(SNodo));
    nuevoNodo->dato=dato;
    nuevoNodo->sig=*lista;
    *lista = nuevoNodo;
}

void slist_agregar_final(SNodo** lista, int dato) {
    SNodo* nuevoNodo = malloc(sizeof(SNodo));
    nuevoNodo->dato = dato;
    nuevoNodo->sig = NULL;
    if(*lista == NULL) *lista = nuevoNodo;

    SNodo* temp = *lista;
    for(;temp->sig!=NULL; temp=temp->sig);
    temp->sig = nuevoNodo;
}

SNodo* slist_agregar_finalR(SNodo* lista, int dato) {
    if(lista == NULL){
        SNodo* nuevoNodo = malloc(sizeof(SNodo));
        nuevoNodo->dato = dato;
        nuevoNodo->sig = NULL;
        return nuevoNodo;
    } 
    else {
        lista->sig = slist_agregar_finalR(lista->sig, dato);
        return lista;
    }
}

int main() {
    SNodo* lista = NULL;
    slist_agregar_inicio(&lista,5);
    slist_agregar_inicio(&lista,8);
    mostrar_lista(lista);
    slist_agregar_final(&lista, 10);
    mostrar_lista(lista);
    lista = slist_agregar_finalR(lista, 7);
    mostrar_lista(lista);

    return 0;
}