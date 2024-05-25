#include <stdio.h>
#include <stdlib.h>

char *get_new_line(void) {
    char  *line = malloc(sizeof(char)), c;
    int i = 0;
    
    while((c = getchar()) != '\n') {
        line[i] = c;
        i++;
        realloc(line,sizeof(char)*i);
    }
    line[i] = '\0';

    return line;
}

int main() {

    printf("Ingrese una linea: ");
    char* frase = get_new_line();
    printf("Linea ingresada: %s\n", frase);

    free(frase);
    
    return 0;
}