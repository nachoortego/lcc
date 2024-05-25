#include "cdlist.h"
#include <stdio.h>

void imprimir(int dato){
    printf("%d ", dato);
}

int main (){
    CDList lista = cdlist_crear();
    lista = cdlist_agregar_final(lista, 1);
    lista = cdlist_agregar_final(lista, 2);
    lista = cdlist_agregar_final(lista, 3);
    lista = cdlist_agregar_final(lista, 4);
    lista = cdlist_agregar_final(lista, 5);
    lista = cdlist_agregar_final(lista, 6);
    lista = cdlist_agregar_final(lista, 7);
    lista = cdlist_agregar_final(lista, 8);

    cdlist_recorrer(lista, imprimir, DLIST_RECORRIDO_HACIA_ADELANTE);
    puts("");
    cdlist_recorrer(lista, imprimir, DLIST_RECORRIDO_HACIA_ATRAS);
    puts("");
    cdlist_destruir(lista);
    return 0;
}