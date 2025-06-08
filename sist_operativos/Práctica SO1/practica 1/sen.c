#include<stdio.h>
#include<signal.h>
#include<stdlib.h>

void ignorar(){
    printf("ignorado\n");
    //SIG_ING
    exit(0);
}

int main(){
    signal(SIGTSTP,SIG_IGN);
    raise(SIGTSTP);
    //sleep(3);
    printf("chau\n");
    return 0;
    
}

