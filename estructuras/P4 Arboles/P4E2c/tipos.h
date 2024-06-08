#ifndef TIPOS_H
#define TIPOS_H

typedef void (*FuncionDestructora)(void *dato);
typedef void *(*FuncionCopia)(void *dato);
typedef void (*FuncionVisitante)(void *dato);
typedef int (*FuncionComparar)(void *dato1, void *dato2);
typedef int (*Predicado) (void *dato);

#endif /* TIPOS_H */