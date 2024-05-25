#include <stdio.h>

void set_first(int a[]) {
    a[0] = 0;
}

int main() {
    
    int arr1[] = {1, 2, 3, 4}, arr2[] = {4, 3, 2, 1};
    

    printf("arr1[0] = %d, arr2[0] = %d\n", arr1[0], arr2[0]);
    set_first(arr1);
    set_first(arr2);
    printf("f(arr1[0]) = %d, f(arr2[0]) = %d", arr1[0], arr2[0]);
    
    return 0;
}