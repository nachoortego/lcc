#include "contacto.h"
#include "utils.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * Crea un nuevo contacto.
 */
Contacto *contacto_crear(char *nombre, char *telefono, unsigned int edad) {
  Contacto *nuevo = malloc(sizeof(Contacto));
  assert(nuevo != NULL);

  nuevo->nombre = malloc(sizeof(char) * (strlen(nombre) + 1));
  assert(nuevo->nombre != NULL);
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
 * Retorna 0 si los contactos tienen el mismo nombre.
 */
int contacto_comparar(Contacto *c1, Contacto *c2) {
  return strcmp(c1->nombre, c2->nombre);
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
 * Hashear un contacto por su nombre.
 */
unsigned contacto_heashear(Contacto *contacto) {
  return KRHash(contacto->nombre);
}

/**
 * Imprime por pantalla un contacto.
 */
void contacto_imprimir(Contacto *contacto) {
  printf("{%s, %s, %d}", contacto->nombre, contacto->tel, contacto->edad);
}