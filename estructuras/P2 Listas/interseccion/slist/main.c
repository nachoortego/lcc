#include <stdio.h>
#include <stdlib.h>
#include "slist.h"
#include "intersecar.h"

static void imprimir_entero(int dato) {
  printf("%d ", dato);
}

int cmp_mod3(int x, int y) {
  return (x % 3) - (y % 3);
}

int cmp_mod4(int x, int y) {
  return (x % 4) - (y % 4);
}

int main() {
  SList list1, list2, inter_mod3, inter_mod4;
  // Lista 1
  list1 = slist_crear();
  list1 = slist_agregar_final(list1, 1);
  list1 = slist_agregar_final(list1, 2);
  list1 = slist_agregar_final(list1, 3);
  // Lista 2
  list2 = slist_crear();
  list2 = slist_agregar_final(list2, 4);
  list2 = slist_agregar_final(list2, 5);
  list2 = slist_agregar_final(list2, 6);
  list2 = slist_agregar_final(list2, 6);
  inter_mod3 = slist_intersecar_custom(list1, list2, cmp_mod3);
  inter_mod4 = slist_intersecar_custom(list1, list2, cmp_mod4);
  
  printf("Modulo 3: ");
  slist_recorrer(inter_mod3, imprimir_entero);
  puts("");
  printf("Modulo 4: ");
  slist_recorrer(inter_mod4, imprimir_entero);
  puts("");

  slist_destruir(list1);
  slist_destruir(list2);
  slist_destruir(inter_mod3);
  slist_destruir(inter_mod4);

  return 0;
}
