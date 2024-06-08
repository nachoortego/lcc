#include "slist.h"
#include <stdio.h>
#include <stdlib.h>


int en_lista(SNodo* n, SNodo** arr, int pos){

    int b = 0;
    for(int i = 0; i < pos && b == 0; i++){
	if(arr[i] == n)
	  b = 1;
    }
    return b;
}


SList hay_ciclo(SList lista){

    if(!lista) return NULL;

    int len = 10;    
    SNodo** arr = malloc(sizeof(struct SNodo*)*len);

    int contador = 0;
    SList aux = lista;
    for(; aux->sig != NULL && !en_lista(aux, arr,contador);
        aux = aux->sig, contador++){
   	
        arr[contador] = aux;

        if(contador == len-1){
            len = len *2;
            arr = (SNodo**) realloc(arr,sizeof(struct SNodo*)*len);
        }
    } 
    

    free(arr);

    if(aux->sig){
   	return aux;
    }
    else{
	return NULL;
    }
}



SList lyt(SList lista){
    SList liebre = lista;
    SList tortuga = lista;
    
    int ciclo = 0;
    while(liebre !=  NULL && liebre->sig!=NULL && !ciclo){
        tortuga = tortuga->sig;
        liebre = liebre->sig->sig; 
        if(tortuga == liebre) 
            ciclo = 1;    
} 

    if(!ciclo)
        return NULL;
    else{
        liebre = lista;
        while(liebre != tortuga){
            tortuga = tortuga->sig;
            liebre = liebre->sig;
        }    
    }
    
    return liebre;
}

void hacer_ciclo(SList lista, int c){

    SList aux1 = lista;
    for(int n = 0;aux1->sig != NULL && n < c;aux1 = aux1->sig, n++); 
    
    if(!aux1) return;
    
    SList aux2 = lista; 
    for(;aux2->sig != NULL;aux2 = aux2->sig); 
    
    aux2->sig = aux1;
}

int main(){
    SList lista = slist_crear();
    SList res;

    lista = slist_agregar_final(lista, 1);
    lista = slist_agregar_final(lista, 2);
    lista = slist_agregar_final(lista, 3);
    lista = slist_agregar_final(lista, 4);
    lista = slist_agregar_final(lista, 5);
    lista = slist_agregar_final(lista, 6);
    lista = slist_agregar_final(lista, 7);


    //res = hay_ciclo(lista);
 
    res = lyt(lista);

    if(res)
        printf("Hay ciclo en %d.\n",res->dato);
    else{
        printf("No hay ciclo.\n");
    }    
     
    hacer_ciclo(lista, 3);
    
    //res = hay_ciclo(lista);
   
    res = lyt(lista);
   
    if(res)
        printf("Hay ciclo en %d.\n",res->dato);
    else{
        printf("No hay ciclo.\n");
    }
    
    SList aux = lista;
    for(int n = 0; n <6; aux = aux->sig,n++);
    aux->sig = NULL; 
    slist_destruir(lista);    
    return 0;
}
