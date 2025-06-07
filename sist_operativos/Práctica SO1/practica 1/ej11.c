#include<stdio.h>
#include<signal.h>
#include<stdlib.h>

void handler_sig1(){
    printf("imprimio CTRL+barra\n");
    exit(0);
}

void handler_sig2(){
    printf("CTRL+c\n");
    signal(SIGINT,SIG_DFL);
}

int main(){
    signal(SIGQUIT,handler_sig1);
    signal(SIGINT,handler_sig2);
    sleep(5);

    sleep(5);
    return 0;
}