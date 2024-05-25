#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int* direccion;
    size_t capacidad;
} ArregloEnteros;

ArregloEnteros* arreglo_enteros_crear(int capacidad) {
    ArregloEnteros* arr = malloc(sizeof(ArregloEnteros));
    int* direccion = malloc(sizeof(int)*capacidad);
    arr->capacidad = capacidad;
    arr->direccion = direccion;
    return arr;
}

void arreglo_enteros_destruir(ArregloEnteros* arreglo) {
    free(arreglo);
}

int arreglo_enteros_leer(ArregloEnteros* arreglo, int pos) {
    if(pos> 0 && pos < arreglo->capacidad)
        return(arreglo->direccion[pos]);
    return -999;
}

void arreglo_enteros_escribir(ArregloEnteros* arreglo, int pos, int dato) {
    if(pos>= 0 && pos < arreglo->capacidad)
        arreglo->direccion[pos] = dato;
}

int arreglo_enteros_capacidad(ArregloEnteros* arreglo) { return arreglo->capacidad; }

void arreglo_enteros_imprimir(ArregloEnteros* arreglo) {
    for (int i = 0; i < arreglo->capacidad; i++) 
        printf("%d ", arreglo->direccion[i]);
    printf("\n");
}

void arreglo_enteros_ajustar(ArregloEnteros* arreglo, int capacidad) {
    arreglo->direccion = realloc(arreglo->direccion,sizeof(int)*capacidad);
    arreglo->capacidad = capacidad;
}

void arreglo_enteros_insertar(ArregloEnteros* arreglo, int pos, int dato) {
    arreglo_enteros_ajustar(arreglo, arreglo->capacidad + 1);
    int flag = 0, temp, temp2;
    for (int i = 0; i < arreglo->capacidad; i++) {
        printf("pos:%d numero:%d\n", i, arreglo->direccion[i]);
        if(i == pos){
            temp = arreglo->direccion[i]; // temp = 3
            arreglo->direccion[i] = dato; // 1 2 17 4 N
            flag = 1;
        }
        else if(flag) {
            temp2 = arreglo->direccion[i]; // temp2 = 4
            arreglo->direccion[i] = temp; // 1 2 17 3 N
            temp = temp2; // temp = 4
        }
    }
}

void arreglo_enteros_eliminar(ArregloEnteros* arreglo, int pos) {
    int flag = 0;
    for (int i = 0; i < arreglo->capacidad; i++) {
        if(i == pos)
            flag = 1;
        if(flag) 
            arreglo->direccion[i] = arreglo->direccion[i+1];
    }
    arreglo_enteros_ajustar(arreglo, arreglo->capacidad-1);
}

struct _Pila {
ArregloEnteros *arr;
int ultimo;
};
typedef struct _Pila *Pila;

Pila pila_crear(int size) {
    Pila pila = malloc(sizeof(Pila));
    pila->arr = arreglo_enteros_crear(size);
    pila->ultimo = -1;

    return pila;
}

void pila_destruir(Pila pila) {
    arreglo_enteros_destruir(pila->arr);
    free(pila);
}

int pila_es_vacia(Pila pila) {
    return arreglo_enteros_capacidad(pila->arr) == 0;
}

int pila_tope(Pila pila) {
    return pila->arr->direccion[pila->ultimo];
}

void pila_apilar(Pila pila, int dato) {
    pila->ultimo++;
    if(arreglo_enteros_capacidad(pila->arr) == pila->ultimo)
        arreglo_enteros_ajustar(pila->arr, pila->ultimo*2);
    arreglo_enteros_escribir(pila->arr, pila->ultimo, dato);
}

void pila_desapilar(Pila pila) {
    arreglo_enteros_eliminar(pila->arr, pila->ultimo);
    pila->ultimo--;
}

void pila_imprimir(Pila pila) {
    for(int i = 0; i < pila->ultimo+1; i++)
        printf("%d ", pila->arr->direccion[i]);
    printf("\n");
}

int main() {
    Pila pila = pila_crear(2);
    pila_imprimir(pila);
    pila_apilar(pila,1);
    pila_imprimir(pila);
    pila_apilar(pila,2);
    pila_imprimir(pila);
    pila_apilar(pila,3);
    pila_imprimir(pila);
    pila_desapilar(pila);
    pila_desapilar(pila);
    pila_imprimir(pila);
    pila_destruir(pila);


    return 0;
}