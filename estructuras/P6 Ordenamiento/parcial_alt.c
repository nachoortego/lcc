#include <stdlib.h>

#define CENTINELA ((Arbol23)1)

struct nodo_arbol23 {
    int k1, k2;
    struct nodo_arbol23 *left, *middle, *right;
};

typedef struct nodo_arbol23* Arbol23;

Arbol23 arbol23_crear() {
    return NULL;
}

int cantidad_de_valores(Arbol23 t) {
    if (t == NULL) 
        return 0;
    if (t->right == CENTINELA)
        return 1;
    return 2;
}

Arbol23 crear_nodo_binario(int x, Arbol23 l, Arbol23 r) {
    Arbol23 nuevo = malloc(sizeof(struct nodo_arbol23));
    nuevo->k1 = x;
    nuevo->left = l;
    nuevo->middle = r;
    nuevo->right = CENTINELA;
    return nuevo;
}

int insertar_impl(Arbol23 t, int x, int *out_x, Arbol23 *out_l, Arbol23 *out_r) {
  int cantValores = cantidad_de_valores(t);
  if (cantValores == 0) {
    *out_x = x;
    *out_l = NULL;
    *out_r = NULL;
    return 1;
  }

  if (t->k1 == x || (cantValores == 2 && t->k2 == x))
    return 0;

  if (cantValores == 1) {
    if (x < t->k1) {
      int res = insertar_impl(t->left, x, out_x, out_l, out_r);
      if (res) {
        t->right = t->middle;
        t->middle = *out_r;
        t->left = *out_l;
        t->k2 = t->k1;
        t->k1 = x;
      }
    }
    else {
      int res = insertar_impl(t->middle, x, out_x, out_l, out_r);
      if (res) {
        t->k2 = x;
        t->middle = *out_l;
        t->right = *out_r;
      }
    }
    return 0;
  }

  int saturado;
  if (x < t->k1) {
    saturado = insertar_impl(t->left, x, out_x, out_l, out_r);
    if (saturado) {
      Arbol23 l = crear_nodo_binario(*out_x, *out_l, *out_r);
      *out_x = t->k1;
      t->k1 = t->k2;
      t->left = t->middle;
      t->middle = t->right;
      t->right = CENTINELA;
      *out_l = l;
      *out_r = t;
    }
  }
  else if (x > t->k2) {
    saturado = insertar_impl(t->right, x, out_x, out_l, out_r);
    if (saturado) {
      Arbol23 r = crear_nodo_binario(*out_x, *out_l, *out_r);
      *out_x = t->k2;
      t->right = CENTINELA;
      *out_l = t;
      *out_r = r;
    }
  }
  else {
    saturado = insertar_impl(t->right, x, out_x, out_l, out_r);
    if (saturado) {
      Arbol23 l = crear_nodo_binario(t->k1, t->left, *out_l);
      // *out_x no cambia, sube
      t->left = *out_r;
      t->middle = t->right;
      t->right = CENTINELA;
      t->k1 = t->k2;
      *out_l = l;
      *out_r = t;
    }
}

  return saturado;
}

Arbol23 arbol23_insertar(Arbol23 t, int x) {
  int out_x;
  Arbol23 out_l, out_r;
  int saturado = insertar_impl(t, x, &out_x, &out_l, &out_r);
  if (saturado)
    return crear_nodo_binario(out_x, out_l, out_r);
  return t;
}