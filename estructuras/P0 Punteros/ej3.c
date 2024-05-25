#include <stdio.h>
#include <stdlib.h>

void set_in(int *n) {
    if(*n != 0) {
        *n = 1;
    }
}

int main() {

    int a = 1, b = 2, c = 0;

    printf("a = %d, b = %d, c = %d\n", a, b, c);
    set_in(&a);
    set_in(&b);
    set_in(&c);
    printf("a = %d, b = %d, c = %d\n", a, b, c);

    return 0;
}