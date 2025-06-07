#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>

int main(){
    int status;
    pid_t pid =fork();
    if(pid==0){
        printf("child pid: %d\n",getpid());
        sleep(2);
        printf("child termine\n");
        //exit(0);
    }
    else{
        printf("parent pid: %d\n", getpid());
        wait(&status);
        printf("el child termino con status: %d\n",status);
    }


    return 0;
}