#include <stdio.h>
#include <stdlib.h>
#include "btree.h"

static void imprimir_entero(int data) {
  printf("%d ", data);
}


int main() {
  BTree ll = btree_unir(1, btree_crear(), btree_crear());
  BTree lr = btree_unir(3, btree_crear(), btree_crear());
  BTree rl = btree_unir(5, btree_crear(), btree_crear());
  BTree rr = btree_unir(7, btree_crear(), btree_crear());
  BTree l = btree_unir(2, ll, lr);
  BTree r = btree_unir(6, rl, rr);
  BTree raiz = btree_unir(4, l, r);

  printf("Recorrido PREORDER:\n");
  btree_recorrer_pre_it(raiz, imprimir_entero);
  puts("");
  
  btree_destruir(raiz);

  return 0;
}
