#ifndef INTERSECAR_H
#define INTERSECAR_H

#include "slist.h"
#include "intersecar.h"

// Tipo de dato que representa una funcion de comparacion de enteros
// Devuelve 0 si ambos son equivalentes
typedef int (*FuncionComparadora)(int, int);

SList slist_intersecar_custom(SList list1, SList list2, FuncionComparadora cmp);

#endif
