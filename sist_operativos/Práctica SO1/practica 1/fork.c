#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>

//proceso q crea otro con fork y mostramos q los pid varian
/*
int main(){

    printf("gaston\n");
    pid_t pid = fork();
    if (pid == 0){
        printf("proceso child: %d\n",getpid());
    }
    else {
        printf("proceso parent: %d\n",getpid());
    }
    printf("quien llego? %d\n",getpid());
    return 0;
}

*/

int main(){
    pid_t pid1=fork();
    pid_t pid2=fork();
    printf("pid1: %d pid2: %d\n",pid1,pid2);
    return 0;
}