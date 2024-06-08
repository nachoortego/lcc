#include "slist.h"

#include <stdio.h>

int meclar_aux(SList* it, SList l) {
    if (l == NULL) return 0;
    if (meclar_aux(it, l->sig)) return 1;

    SList a = *it;
    SList b = a->sig;

    if (a == l || b == l) {
        l->sig = NULL;
        return 1;
    }

    a->sig = l;
    l->sig = b;

    *it = b;

    return 0;
}

void mezclar(SList l) {
    meclar_aux(&l, l);
}

void mostrar_int(int x) {
    printf("%d ", x);
}

int main() {
    SList l = slist_crear();

    int n;
    scanf("%d", &n);

    for (int i = n; i >= 1; --i)
        l = slist_agregar_inicio(l, i);

    mezclar(l);

    slist_recorrer(l, mostrar_int);
    printf("\n");
}