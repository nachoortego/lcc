#include <stdio.h>
#include <stdlib.h>

int main() {
    
    int *a = malloc(sizeof(int));

    printf("&a = %p, malloc(xd) = %p",a,malloc(sizeof(float)*99999999999999999999999999999999999)); // This line is added to the original code

    return 0;
}