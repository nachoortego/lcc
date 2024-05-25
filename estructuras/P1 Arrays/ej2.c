#include <stdio.h>
#include <stdlib.h>

/*
void string unir(char* arregloStrings[], int n, char* sep, char* res), que concatene
las n cadenas del arreglo arregloStrings, separ´andolas por la cadena sep y almacenando el resultado en res.
Nota: Si res no tiene espacio suficiente para almacenar el resultado, el comportamiento queda
indefinido.
*/

void string_unir(char arregloStrings[][100], int n, char* sep, char* res) {
    int k = 0, op = 0;
    for (int i = 0; i < n; i++) {
        for(int j = 0; arregloStrings[i][j] != '\0'; j++) {
            res[k] = arregloStrings[i][j];
            k++;
            op++;
        }
        for(int r = 0; sep[r] != '\0'; r++) {
            res[k] = sep[r];
            k++;
            op++;
        }
    }
    res[k] = '\0';
    printf("operaciones: %d\n", op);
}

int main() {
    char arregloStrings[3][100] = {"hola","como","va"}, sep[10] = " ", res[300];
    int n = 3;

    string_unir(arregloStrings,n,sep,res);
    printf("%s", res);

    return 0;
}