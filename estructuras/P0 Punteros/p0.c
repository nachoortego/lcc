#include <stdlib.h>
#include <stdio.h>
#include <time.h>


//12. Defina una estructura para representar puntos en el plano, y una funci´on medio que dados dos de
//estos puntos, calcule el punto medio.

typedef struct {
    int palo; // 1: espada 2:basto 3:oro 4:copa
    int num;
} Carta;

typedef struct {
    Carta carta[48];
} Mazo;

void llenar (Mazo *mazo) {
    Carta temp;
    int c = 0;
    for (int i=1; i<=4;i++) {
        for(int n=1; n<=12;n++) {
            temp.palo = i;
            temp.num = n;
            mazo->carta[c++] = temp;
        }
    }
    
}

Carta azar(Mazo mazo) {
    return mazo.carta[rand() % 48];
}

int main () {
    Mazo mazo;
    srand(time(NULL));
    llenar(&mazo);

    for (int i=0; i<48;i++) {
        printf("Palo: %d Numero: %d\n", mazo.carta[i].palo, mazo.carta[i].num);
    }

    Carta random = azar(mazo);
    
    printf("\n\nCarta no aleatoria: %d %d\n\n", random.palo, random.num);

    return 0;
}