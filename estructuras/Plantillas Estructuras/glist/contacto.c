#include "contacto.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Crea un nuevo contacto.
 */
Contacto *contacto_crear(char *nombre, char *telefono, unsigned int edad) {
  Contacto *nuevo = malloc(sizeof(Contacto));

  nuevo->nombre = malloc(sizeof(char) * (strlen(nombre) + 1));
  strcpy(nuevo->nombre, nombre);

  nuevo->tel = malloc(sizeof(char) * (strlen(telefono) + 1));
  strcpy(nuevo->tel, telefono);

  nuevo->edad = edad;

  return nuevo;
}

/**
 * Crea una copia física del contacto.
 */
Contacto *contacto_copia(Contacto *contacto) {
  Contacto *copia =
      contacto_crear(contacto->nombre, contacto->tel, contacto->edad);
  return copia;
}

/**
 * Compara el nombre de dos contactos en orden lexicográfico. Devuelve 0 si son
 * iguales, < 0 si el primero es menor que el segundo y > 0 si el primero es
 * mayor que el segundo.
 */
int contacto_comparar(Contacto *c1, Contacto *c2) {
  return (strcmp(c1->nombre, c2->nombre));
}

/**
 * Función destructora de un contacto.
 */
void contacto_destruir(Contacto *contacto) {
  free(contacto->nombre);
  free(contacto->tel);
  free(contacto);
}

/**
 * Imprime por pantalla un contacto.
 */
void contacto_imprimir(Contacto *contacto) {
  printf("%s, %s, %d.\n", contacto->nombre, contacto->tel, contacto->edad);
}
