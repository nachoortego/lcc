#ifndef PILA_H

#include "tipos.h"

typedef struct _Pila* Pila;

Pila pila_crear();

int pila_vacia (Pila p);

Pila pila_apilar(Pila, void* dato, FuncionCopia);

void* pila_tope(Pila, FuncionCopia);

Pila pila_desapilar(Pila, FuncionDestructora);

void pila_destruir(Pila p, FuncionDestructora destruir);

#endif /* PILA_H */