#ifndef __HEAP__
#define __HEAP__

typedef int (*FuncionComparadora)(void *, void *);
typedef void (*FuncionVisitante)(void *dato);

typedef struct _BHeap {
  void **arr;
  int capacidad;
  int ultimo;
  FuncionComparadora comp;
} *BHeap;

/*  
  * Crea un heap vacio con una capacidad y una funcion de comparacion dadas.
*/
BHeap bheap_crear(int, FuncionComparadora);

/*  
  * Destruye el heap.
*/
void bheap_destruir(BHeap);

/*
  * Devuelve hijo izquierdo del nodo.
*/
int left(int);

/*
  * Devuelve hijo derecho del nodo.
*/
int right(int);

/*
  * Devuelve padre del nodo.
*/
int father(int);

/*  
  * Retorna 1 si el heap esta vacio y 0 en caso contrario.
*/
int bheap_es_vacio(BHeap);

/*  
  * Recorre los nodos utilizando busqueda por extension, aplicando la funcion.
dada en cada elemento.
*/
void bheap_recorrer(BHeap, FuncionVisitante);

/*  
  * Agrega un elemento al heap, realocando el arreglo en caso de ser necesario.
*/
BHeap bheap_insertar(BHeap, void*);

/*  
  * Elimina un elemento del heap.
*/
BHeap bheap_eliminar(BHeap, int);

#endif /* __HEAP__ */
