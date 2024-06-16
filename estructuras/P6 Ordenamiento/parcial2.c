#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#define CENTINELA ((Arbol23)1)

typedef struct nodo_arbol23 *Arbol23;

struct nodo_arbol23 {
  int k1, k2;
  Arbol23 left, middle, right;
};


Arbol23 arbol23_crear() { return NULL; }

int cantidad_de_valores(Arbol23 t) {
  if(!t)
    return 0;
  if(t->right == CENTINELA)
    return 1;
  return 2;
}

Arbol23 crear_nodo_binario(int x, Arbol23 l, Arbol23 r) {
  Arbol23 newTree = malloc(sizeof(struct nodo_arbol23));
  newTree->k1 = x;
  newTree->right = CENTINELA;
  newTree->left = l;
  newTree->middle = r;

  return newTree;
}

int insertar_impl(Arbol23 t, int x, int* out_x, Arbol23* out_l, Arbol23* out_r) {
  if(cantidad_de_valores(t) == 0) {
    out_x = out_l = out_x = NULL;
    t = crear_nodo_binario(x, arbol23_crear(), arbol23_crear());
    return 0; 
  }
  if(cantidad_de_valores(t) == 1) {
    t->right = NULL;
    if(x < t->k1) {
      t->k2 = t->k1;
      t->k1 = x;
    }
    else
      t->k2 = x;
    out_x = out_l = out_x = NULL;

    return 0;
  }
  if(cantidad_de_valores(t) == 2) {
    int left, middle, right;
    if(x > t->k2)
      left = t->k1, middle = t->k2, right = x;
    if(x > t->k1 && x <= t->k2)
      left = t->k1, middle = x, right = t->k2;
    else
      left = x, middle = t->k1, right = t->k2;

    *out_x = middle;
    *out_l = left;
    *out_r = right;
    return 0;
  }
}

Arbol23 insertar(Arbol23 t, int x) {
  if(cantidad_de_valores(t) == 0 || t->left == NULL) { // si es hoja
    int* out_x;
    Arbol23* out_l;
    Arbol23* out_r;
    int impl = insertar_impl(t,x,out_x, out_l, out_r);
    if(impl == 1) {

    }
    else
      return t;
  }
  else{
    if(cantidad_de_valores(t) == 1) {
      if(x > t->k1)
        insertar(t->middle, x);
      else
        insertar(t->left, x);
    }
    if(cantidad_de_valores(t) == 2) {
      if(x > t->k2)
        insertar(t->right, x);
      if(x > t->k1 && x <= t->k2)
        insertar(t->middle, x);
      else
        insertar(t->left, x);
    }
  }
}

int main() {

  return 0;
}