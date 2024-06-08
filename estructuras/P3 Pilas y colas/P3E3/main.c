#include <stdlib.h> 
#include <string.h>
#include <stdio.h>
#include "glist.h"

typedef struct {
    char* nombre;
    char* telefono;
    int edad;
} Contacto;

void* copiaContacto (void* data) {
    Contacto* contacto = (Contacto*) data;
    Contacto* nuevo = malloc(sizeof(Contacto));

    nuevo->nombre = malloc(sizeof(char)*(strlen(contacto->nombre)+1));
    strcpy(nuevo->nombre, contacto->nombre);
    nuevo->telefono = malloc(sizeof(char)*(strlen(contacto->telefono)+1));
    strcpy(nuevo->telefono, contacto->telefono);
    nuevo->edad = contacto->edad;

    return nuevo;
}

void imprimirContacto (void* data) {
    Contacto* contacto = (Contacto*) data;
    printf("Nombre: %s - Telefono: %s - Edad: %d\n", contacto->nombre, contacto->telefono, contacto->edad);
}

void destruirContacto (void* data) {
    Contacto* contacto = (Contacto*) data;

    free(contacto->nombre);
    free(contacto->telefono);
    free(contacto);
}



int main () {
    GList lista = glist_crear();
    
    Contacto* contacto = malloc(sizeof(Contacto));
    contacto->nombre = malloc(sizeof(char)*100);
    contacto->telefono = malloc(sizeof(char)*100);

    strcpy(contacto->nombre, "Bautista");
    strcpy(contacto->telefono, "34356535");
    contacto->edad = 22;
    glist_agregar_final(lista, contacto, copiaContacto);

    strcpy(contacto->nombre, "Sebastian");
    strcpy(contacto->telefono, "34254535");
    contacto->edad = 23;
    glist_agregar_final(lista, contacto, copiaContacto);

    strcpy(contacto->nombre, "Federico");
    strcpy(contacto->telefono, "34298735");
    contacto->edad = 48;
    glist_agregar_final(lista, contacto, copiaContacto);

    strcpy(contacto->nombre, "Valentina");
    strcpy(contacto->telefono, "34254334");
    contacto->edad = 25;
    glist_agregar_final(lista, contacto, copiaContacto);

    destruirContacto(contacto);


    printf("Lista Original:\n");
    glist_recorrer(lista, imprimirContacto);


    printf("\nLista Reversa:\n");
    //glist_revertir(lista);
    glist_revertir_mejorado(lista);
    glist_recorrer(lista, imprimirContacto);

    glist_destruir(lista, destruirContacto);

    return 0;
}