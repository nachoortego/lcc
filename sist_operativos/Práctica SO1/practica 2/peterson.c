#include <pthread.h>
#include <unistd.h>
#include <stdio.h>

#define NUM_VISITANTES 40000000

int visitantes = 0;
//int flag = 0; //0 = region critica libre, 1 = ocupada
int turno = 0; //0 = no se asigno turno, indica a que molinete le toca 1 o 2
int flag[2] = {0,0}; // si es 0 no tengo intencion de entrar a la rc, si es 1 si


void* molinete() {
    for(int i=0; i< NUM_VISITANTES/2 ; i++){

        flag[0] = 1;//molinete 1 tiene intencion de entrar
        turno = 2;
        while(flag[1] == 1 && turno == 2)
        {;}

        //region critica
        visitantes = visitantes + 1;

        flag[0] = 0;
    }
}


void* molinete2() {
for(int i=0; i< NUM_VISITANTES/2 ; i++){
    flag[1] = 1;//molinete 1 tiene intencion de entrar
    turno = 1;
    while(flag[0] == 1 && turno == 1)
    {;}

    //region critica
    visitantes = visitantes + 1;

    flag[1] = 0;
    }
}

int main() {
pthread_t t0, t1;
pthread_create(&t0, NULL, molinete, NULL);
pthread_create(&t1, NULL, molinete2, NULL);
pthread_join(t0, NULL);
pthread_join(t1, NULL);

printf("La cantidad final es %d\n", visitantes);

return 0;
}