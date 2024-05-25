#include <stdio.h>
#include <stdlib.h>
#include "slist.h"

/*
a) slist longitud que devuelve la longitud de una lista.
b) slist concatenar que devuelve la concatenaci´on de dos listas, modificando la primera.
c) slist insertar que inserta un dato en una lista en una posicion arbitraria.
d) slist eliminar que borra de una lista un dato apuntado en una posici´on arbitraria.
e) slist contiene que determina si un elemento esta en una lista dada.
f) slist indice que devuelve la posicion de la primera ocurrencia de un elemento si el mismo esta en
la lista dada, y -1 en caso que no este.
g) slist intersecar que devuelve una nueva lista con los elementos comunes (independientemente de
la posicion) de dos listas dadas por par´ametro. Las listas originales no se modifican.
h) slist intersecar custom que trabaja como la anterior pero recibe un par´ametro extra que es un
puntero a una funci´on de comparaci´on que permite definir la noci´on de igualdad a ser usada al
comparar elementos por igualdad.
i) slist ordenar que ordena una lista de acuerdo al criterio dado por una funci´on de comparaci´on
(que usa los mismos valores de retorno que strcmp()) pasada por par´ametro.
j) slist reverso que obtenga el reverso de una lista.
k) slist intercalar que dadas dos listas, intercale sus elementos en la lista resultante. Por ejemplo,
dadas las listas [1, 2, 3, 4] y [5, 6], debe obtener la lista [1, 5, 2, 6, 3, 4].
l) slist partir que divide una lista a la mitad. En caso de longitud impar (2n + 1), la primer lista
tendr´a longitud n + 1 y la segunda n. Retorna un puntero al primer elemento de la segunda mitad,
siempre que sea no vacia.*/

SList slist_partir(SList* lista) {
  SList segundaMitad = slist_crear();
  int mitad = slist_longitud(lista) / 2;
  int i = 0;
  SNodo* temp = *lista;
  for(; i != (mitad+1); temp = temp->sig, i++);
  SNodo* primerELem = temp->sig;
  temp->sig = NULL;
  for(; primerELem != NULL; primerELem = primerELem->sig)
    segundaMitad = slist_agregar_final(segundaMitad, primerELem->dato);

  return segundaMitad;
}

SList slist_intercalar(SList lista1, SList lista2) {
  SList intercalada = slist_crear();
  SNodo* temp1 = lista2;
  SNodo* temp2 = lista1;
  if (slist_longitud(lista1) > slist_longitud(lista2)){
    SNodo* temp1 = lista1;
    SNodo* temp2 = lista2;
  }
  for(; temp1 != NULL; temp1 = temp1->sig) {
    intercalada = slist_agregar_final(intercalada, temp1->dato);
    if(temp2 != NULL) {
      intercalada = slist_agregar_final(intercalada, temp2->dato);
      temp2 = temp2->sig;
    }
  }
  return intercalada;
}

SList slist_reverso(SList inicio) {
  SList reverso = slist_crear();
  for (SNodo* temp = inicio; temp != NULL; temp = temp->sig)
    reverso = slist_agregar_inicio(reverso,temp->dato);
  return reverso;
}


int compara_numeros(int a, int b) { return a-b; }

SList slist_ordenar(SList inicio, int (*FuncionOrden) (int, int)) { // REVISARRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR
  for (SNodo* uno = inicio; uno->sig != NULL; uno = uno->sig) {
    for (SNodo* dos = inicio; dos != uno; dos = dos->sig) {
      if (FuncionOrden(dos->dato,dos->sig->dato)) {
        SNodo* aux = dos;
        dos = dos->sig;
        dos->sig = aux;
    }
  }
  return inicio;
}
}

int iguala_numeros(int a, int b) { return a == b; }

SList slist_intersecar_custom(SList lista1, SList lista2, int (*FuncionComparacion) (int, int)) {
  SList nuevaLista = slist_crear();
  for (SNodo* temp1 = lista1; temp1 != NULL ; temp1 = temp1->sig)
    for (SNodo* temp2 = lista2; temp2 != NULL ; temp2 = temp2->sig)
      if(FuncionComparacion(temp1->dato, temp2->dato))
        nuevaLista = slist_agregar_inicio(nuevaLista, temp1->dato);
  return nuevaLista;
}

SList slist_intersecar(SList lista1, SList lista2) {
  SList nuevaLista = slist_crear();
  for (SNodo* temp1 = lista1; temp1 != NULL ; temp1 = temp1->sig)
    for (SNodo* temp2 = lista2; temp2 != NULL ; temp2 = temp2->sig)
      if(temp1->dato == temp2->dato)
        nuevaLista = slist_agregar_inicio(nuevaLista, temp1->dato);
  return nuevaLista;
}

SList slist_intersecar_2(SList lista1, SList lista2){
  SList nuevaLista = slist_crear();
  for(SNodo* temp = lista1; temp != NULL; temp = temp->sig){
    if(slist_contiene(lista2, temp->dato))
      nuevaLista = slist_agregar_final(nuevaLista, temp->dato);
  }

  return nuevaLista;
}

int slist_indice(SList inicio, int dato) {
  int indice = -1;
  int i = 0;
  for (SNodo* temp = inicio; temp != NULL; temp = temp->sig, i++)
    if (temp->dato == dato && indice == -1)
      indice = i;

  return indice;
}

int slist_contiene(SList inicio, int dato) {
  int encontrado = 0;
  for (SNodo* temp = inicio; temp != NULL; temp = temp->sig)
    if (temp->dato == dato)
      encontrado = 1;
  return encontrado;
}

SList slist_insertar(SList inicio, int dato, int pos) {
  if(inicio == NULL || pos == 0) {
    SNodo* nuevoNodo = malloc(sizeof(SNodo));
    nuevoNodo->dato = dato;
    nuevoNodo->sig = inicio;
    return nuevoNodo;
  }
  inicio->sig = slist_insertar(inicio->sig,dato,pos-1);
  return inicio;
}

SList slist_borrar(SList inicio, int pos) {
  if(inicio->sig == NULL || pos == 0) {
    SNodo* nodoEliminar = inicio;
    inicio = inicio->sig;
    free(nodoEliminar);
    return inicio;
  }
  inicio->sig = slist_borrar(inicio->sig,pos-1);
  return inicio;
}

int slist_longitud (SList inicio) {
  int i = 0;
  for(SNodo* temp = inicio; temp != NULL; temp = temp->sig) 
    i++;
  return i;
}
 
SList slist_concatenar (SList primera, SList segunda) {
  SNodo* temp = primera;
  for(; temp->sig != NULL; temp = temp->sig);
  temp->sig = segunda;
  return primera;
}

static void imprimir_entero(int dato) {
  printf("%d ", dato);
}

int main(int argc, char *argv[]) {

  SList lista = slist_crear();

  lista = slist_agregar_inicio(lista, 3);
  lista = slist_agregar_inicio(lista, 2);
  lista = slist_agregar_inicio(lista, 1);
  lista = slist_agregar_final(lista, 7);

  SList lista2 = slist_crear();

  lista2 = slist_agregar_inicio(lista2, 6);
  lista2 = slist_agregar_inicio(lista2, 1);
  lista2 = slist_agregar_inicio(lista2, 2);
  lista2 = slist_agregar_final(lista2, 9);

  slist_recorrer(lista, imprimir_entero);
  puts("");

  slist_recorrer(lista2, imprimir_entero);
  puts("");

  SList intercalada = slist_intercalar(lista, lista2);
  slist_recorrer(intercalada, imprimir_entero);
  puts("");

  SList intersecada = slist_intersecar(lista, lista2);
  SList intersecadaCustom = slist_intersecar_custom(lista, lista2, iguala_numeros);
  SList intersecada2 = slist_intersecar_2(lista, lista2);

  printf("INTERSECADAS:\n");
  slist_recorrer(intersecada, imprimir_entero);
  puts("");
  slist_recorrer(intersecadaCustom, imprimir_entero);
  puts("");
  slist_recorrer(intersecada2, imprimir_entero);
  puts("");

  slist_concatenar(lista, lista2);

  lista = slist_insertar(lista, 23, 0);
  lista = slist_insertar(lista, 24, 2);

  slist_recorrer(lista, imprimir_entero);
  puts("");

  lista = slist_borrar(lista, 0);
  slist_recorrer(lista, imprimir_entero);
  puts("");
  lista = slist_borrar(lista, 34);
  slist_recorrer(lista, imprimir_entero);
  puts("");

  printf("Longitud lista 1: %d", slist_longitud(lista));
  puts("");

  printf("Contiene %d?: %d", 24, slist_contiene(lista,24));
  puts("");

  printf("Contiene %d?: %d", 5, slist_contiene(lista,5));
  puts("");
  
  printf("Indice %d?: %d", 3, slist_indice(lista,3));
  puts("");

  printf("Indice %d?: %d", 6, slist_indice(lista,6));
  puts("");

  lista = slist_ordenar(lista,compara_numeros);
  slist_recorrer(lista, imprimir_entero);
  puts("");

  lista = slist_reverso(lista);
  slist_recorrer(lista, imprimir_entero);
  puts("");


  SList segundaMitad = slist_partir(&lista);
  printf("PRIMERA MITAD: ");
  slist_recorrer(lista, imprimir_entero);
  printf("SEGUNDA MITAD: ");
  slist_recorrer(segundaMitad, imprimir_entero);
  puts("");

  slist_destruir(lista);

  return 0;
}
