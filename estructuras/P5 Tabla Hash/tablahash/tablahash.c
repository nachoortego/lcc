#include "tablahash.h"
#include <assert.h>
#include <stdlib.h>

/**
 * Casillas en la que almacenaremos los datos de la tabla hash.
 */
typedef struct {
  void *dato;
} CasillaHash;

/**
 * Estructura principal que representa la tabla hash.
 */
struct _TablaHash {
  CasillaHash *elems;
  unsigned numElems;
  unsigned capacidad;
  FuncionCopiadora copia;
  FuncionComparadora comp;
  FuncionDestructora destr;
  FuncionHash hash;
};

/**
 * Crea una nueva tabla hash vacia, con la capacidad dada.
 */
TablaHash tablahash_crear(unsigned capacidad, FuncionCopiadora copia,
                          FuncionComparadora comp, FuncionDestructora destr,
                          FuncionHash hash) {

  // Pedimos memoria para la estructura principal y las casillas.
  TablaHash tabla = malloc(sizeof(struct _TablaHash));
  assert(tabla != NULL);
  tabla->elems = malloc(sizeof(CasillaHash) * capacidad);
  assert(tabla->elems != NULL);
  tabla->numElems = 0;
  tabla->capacidad = capacidad;
  tabla->copia = copia;
  tabla->comp = comp;
  tabla->destr = destr;
  tabla->hash = hash;

  // Inicializamos las casillas con datos nulos.
  for (unsigned idx = 0; idx < capacidad; ++idx) {
    tabla->elems[idx].dato = NULL;
  }

  return tabla;
}

/**
 * Retorna el numero de elementos de la tabla.
 */
int tablahash_nelems(TablaHash tabla) { return tabla->numElems; }

/**
 * Retorna la capacidad de la tabla.
 */
int tablahash_capacidad(TablaHash tabla) { return tabla->capacidad; }

/**
 * Destruye la tabla.
 */
void tablahash_destruir(TablaHash tabla) {

  // Destruir cada uno de los datos.
  for (unsigned idx = 0; idx < tabla->capacidad; ++idx)
    if (tabla->elems[idx].dato != NULL)
      tabla->destr(tabla->elems[idx].dato);

  // Liberar el arreglo de casillas y la tabla.
  free(tabla->elems);
  free(tabla);
  return;
}

/**
 * Inserta un dato en la tabla, o lo reemplaza si ya se encontraba.
 * IMPORTANTE: La implementacion no maneja colisiones.
 */
void tablahash_insertar(TablaHash tabla, void *dato) {

  // Calculamos la posicion del dato dado, de acuerdo a la funcion hash.
  unsigned idx = tabla->hash(dato) % tabla->capacidad;

  // Insertar el dato si la casilla estaba libre.
  if (tabla->elems[idx].dato == NULL) {
    tabla->numElems++;
    tabla->elems[idx].dato = tabla->copia(dato);
    return;
  }
  // Sobrescribir el dato si el mismo ya se encontraba en la tabla.
  else if (tabla->comp(tabla->elems[idx].dato, dato) == 0) {
    tabla->destr(tabla->elems[idx].dato);
    tabla->elems[idx].dato = tabla->copia(dato);
    return;
  }
  // linear probing si hay colision.
  else {
    unsigned i = idx + 1;
    while(i != idx) {
      if(i == tabla->capacidad) // Si llega al final de la tabla
        i = 0;
      if (tabla->elems[i].dato == NULL) {
        tabla->numElems++;
        tabla->elems[i].dato = tabla->copia(dato);
        return;
      }
      i++;
    }
    perror("No hay lugar en la tabla");
    return;
  }
}

/**
 * Retorna el dato de la tabla que coincida con el dato dado, o NULL si el dato
 * buscado no se encuentra en la tabla.
 */
void *tablahash_buscar(TablaHash tabla, void *dato) {

  // Calculamos la posicion del dato dado, de acuerdo a la funcion hash.
  unsigned idx = tabla->hash(dato) % tabla->capacidad;

  // Retornar NULL si la casilla estaba vacia.
  if (tabla->elems[idx].dato == NULL)
    return NULL;
  // Retornar el dato de la casilla si hay coincidencia.
  else if (tabla->comp(tabla->elems[idx].dato, dato) == 0)
    return tabla->elems[idx].dato;
  // Buscar utilizando linear probing si hay colisiones.
  else {  
    unsigned i = idx + 1;
    while(i != idx) {
      if(i == tabla->capacidad) // Si llega al final de la tabla, vuelve al principio.
        i = 0;
      if (tabla->elems[i].dato == NULL) // Si encuentra una casilla vacía, termina la búsqueda.
        return NULL;
      if (tabla->comp(tabla->elems[i].dato, dato) == 0) // Si encuentra el dato, lo retorna.
        return tabla->elems[i].dato;
      i++;
    }
    return NULL; // Si no encuentra el dato en toda la tabla, retorna NULL.
  }
}


/**
 * Elimina el dato de la tabla que coincida con el dato dado.
 */
void tablahash_eliminar(TablaHash tabla, void *dato) {

  // Calculamos la posicion del dato dado, de acuerdo a la funcion hash.
  unsigned idx = tabla->hash(dato) % tabla->capacidad;

  // Si la casilla inicial está vacía, significa que el dato no está en la tabla.
  if (tabla->elems[idx].dato == NULL) {
    perror("El dato no está en la tabla");
    return;
  }

  // Si el dato está en la posición inicial
  if (tabla->comp(tabla->elems[idx].dato, dato) == 0) {
    tabla->numElems--;
    tabla->destr(tabla->elems[idx].dato);
    tabla->elems[idx].dato = NULL;
    return;
  }

  // Buscar utilizando linear probing si hay colisiones.
  unsigned i = idx + 1;
  while (i != idx) {
    if (i == tabla->capacidad) // Si llega al final de la tabla, vuelve al principio.
      i = 0;
    if (tabla->elems[i].dato == NULL) // Si encuentra una casilla vacía, termina la búsqueda.
      return;
    if (tabla->comp(tabla->elems[i].dato, dato) == 0) { // Si encuentra el dato, lo elimina.
      tabla->numElems--;
      tabla->destr(tabla->elems[i].dato);
      tabla->elems[i].dato = NULL;
      return;
    }
    i++;
  }
  // No encuentra el dato en toda la tabla.
}
