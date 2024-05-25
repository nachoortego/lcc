#include <stdio.h>

void swap(int *a, int *b) {
    int temp_a = *a;
    *a = *b;
    *b = temp_a; 
}

int main() {
    
    int a = 1, b = 2, c = 0;

    printf("a = %d, b = %d, c = %d\n", a, b, c);

    swap(&a, &b);

    printf("a = %d, b = %d, c = %d\n", a, b, c);
    
    swap(&a, &c);

    printf("a = %d, b = %d, c = %d\n", a, b, c);

    return 0;
}