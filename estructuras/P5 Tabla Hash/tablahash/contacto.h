#ifndef __CONTACTO_H__
#define __CONTACTO_H__

typedef struct {
  char *nombre;
  char *tel;
  unsigned int edad;
} Contacto;

/**
 * Crea un nuevo contacto.
 */
Contacto *contacto_crear();

/**
 * Crea una copia física del contacto.
 */
Contacto *contacto_copia(Contacto *contacto);

/**
 * Retorna 0 si los contactos tienen el mismo nombre.
 */
int contacto_comparar(Contacto *c1, Contacto *c2);

/**
 * Función destructora de un contacto.
 */
void contacto_destruir(Contacto *contacto);

/**
 * Hashear un contacto por su nombre.
 */
unsigned contacto_heashear(Contacto *contacto);

/**
 * Imprime por pantalla un contacto.
 */
void contacto_imprimir(Contacto *contacto);

#endif /* __CONTACTO_H__ */