#include <stdio.h>
#include <stdlib.h>

int main() {
    int num = 4;
    char c = "a";
    char* arr  = "Hola";

    printf("la variable num vale %d y esta en %p\n", num, &num);
    printf("la variable c vale '%c' y esta en %p\n", c, &c);
    printf("la variable arr vale '%s' y esta en %p\n", arr, &arr);

    printf("La palabra %s tiene 4 letras, ubicadas en:\n%c: %p\n%c: %p\n%c: %p\n%c: %p\n", arr, arr[0], &arr[0], arr[1], &arr[1], arr[2], &arr[2], arr[3], &arr[3]);
    printf("la variable arr esta ubicada en %p, al igual que arr[0], ubicada en %p", arr, &arr[0]);

    return 0;
}