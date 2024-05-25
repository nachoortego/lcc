#include <stdio.h>
#include <stdlib.h>
#include "btree.h"

static void imprimir_entero(int data) {
  printf("%d ", data);
}

int main() {
  BTree ll = btree_unir(1, btree_crear(), btree_crear());
  BTree l = btree_unir(2, ll, btree_crear());
  BTree r = btree_unir(3, btree_crear(), btree_crear());
  BTree raiz = btree_unir(4, l, r);
/*
    4
  2   3
1
*/
  BTree ll2 = btree_unir(1, btree_crear(), btree_crear());
  BTree lr2 = btree_unir(5, btree_crear(), btree_crear());
  BTree l2 = btree_unir(2, ll2, lr2);
  BTree rr2 = btree_unir(7, btree_crear(), btree_crear());
  BTree rl2 = btree_unir(6, btree_crear(), btree_crear());
  BTree r2 = btree_unir(3, rl2, rr2);
  BTree raiz2 = btree_unir(4, l2, r2);
/*
   4
 2   3
1 5 6 7
*/
  btree_recorrer(raiz, BTREE_RECORRIDO_PRE, imprimir_entero);
  puts("");
  btree_recorrer(raiz, BTREE_RECORRIDO_IN, imprimir_entero);
  puts("");
  btree_recorrer(raiz, BTREE_RECORRIDO_POST, imprimir_entero);
  puts("");
  printf("Nodos: %d\n",btree_nnodos(raiz));

  printf("1: %d\n",btree_buscar(raiz, 1));
  printf("2: %d\n",btree_buscar(raiz, 2));
  printf("3: %d\n",btree_buscar(raiz, 3));
  printf("4: %d\n",btree_buscar(raiz, 4));
  printf("5: %d\n",btree_buscar(raiz, 5));

  printf("Arbol copia:\n");
  btree_recorrer(btree_copiar(raiz), BTREE_RECORRIDO_POST, imprimir_entero);
  puts("");
  printf("Altura: %d\n",btree_altura(raiz));

  printf("Numero de nodos Profundidad 0: %d\n",btree_nnodos_profundidad(raiz, 0));
  printf("Numero de nodos Profundidad 1: %d\n",btree_nnodos_profundidad(raiz, 1));
  printf("Numero de nodos Profundidad 2: %d\n",btree_nnodos_profundidad(raiz2, 2));

  printf("Suma del arbol: %d\n",btree_sumar(raiz));

  btree_recorrer_bfs(raiz, imprimir_entero);
  puts("");
  btree_recorrer_bfs(raiz2, imprimir_entero);
  puts("");

  btree_destruir(raiz);
  btree_destruir(raiz2);

  return 0;
}