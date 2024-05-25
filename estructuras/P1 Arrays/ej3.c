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
    realloc(arreglo->direccion,sizeof(int)*capacidad);
    arreglo->capacidad = capacidad;
}

void arreglo_enteros_insertar(ArregloEnteros* arreglo, int pos, int dato) {
    arreglo_enteros_ajustar(arreglo, arreglo->capacidad + 1);
    int flag = 0, temp, temp2;
    for (int i = 0; i < arreglo->capacidad; i++) {
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
int main() {
    ArregloEnteros* arr = arreglo_enteros_crear(4);
    arreglo_enteros_escribir(arr,0,1);
    arreglo_enteros_escribir(arr,1,2);
    arreglo_enteros_escribir(arr,2,3);
    arreglo_enteros_escribir(arr,3,4);
    printf("Array: \n");
    arreglo_enteros_imprimir(arr);
    printf("pos 1: %d\n", arreglo_enteros_leer(arr,1));
    printf("capacidad: %d\n", arreglo_enteros_capacidad(arr));
    arreglo_enteros_insertar(arr, 2, 17);
    printf("Insertando 17 en posicion 2: \n");
    arreglo_enteros_imprimir(arr);
    arreglo_enteros_eliminar(arr, 0);
    printf("Eliminando posicion 0: \n");
    arreglo_enteros_imprimir(arr);
    arreglo_enteros_eliminar(arr, 2);
    printf("Eliminando posicion 2: \n");
    arreglo_enteros_imprimir(arr);
    arreglo_enteros_destruir(arr);

    return 0;
}