#include<stdio.h>
#include<unistd.h>
#include<signal.h>
#include<stdlib.h>
/*
void handler_zero_division(int signa){
        printf("DIVISION POR 0\n");
        exit(0);
}

int main(){
    void(*signareturn)(int);
    signareturn=signal(SIGFPE,handler_zero_division);
    int a=1;
    int b=0;
    int res=1/0;
    printf("%d\n",res);
    return 0;
}

*/
/*
se sigo con fg

int main(){
    raise(SIGSTOP);
    
    printf("Chau\n");
    return 0;
}
*/
/* usar CONTROL+Z para pausar y despues fg para continuar
int main(){
    printf("QUE\n");
    sleep(3);
    printf("listo\n");
    return 0;
}
*/

void handler_zero_division(int signa){
        printf("Me estropearon\n");
        exit(0);
}

int main(){
    void(*signareturn)(int);
    signareturn=signal(SIGSTOP,handler_zero_division);
    raise(SIGSTOP);
    printf("%d\n",3);
    return 0;
}