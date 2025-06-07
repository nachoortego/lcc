#include<stdio.h>
#include<signal.h>
#include<stdlib.h>
#include<unistd.h>
#include<sys/types.h>
#include<string.h>

int main(){
    int fd[2];
    pipe(fd);
    char buffer[]="hola mundo";
    char readBuffer;
    pid_t pid=fork();
    if(pid==0){
        printf("Child coerriendo...\n");
        close(fd[1]);
        int numread=1;
        while(numread!= 0){    
        numread=read(fd[0],&readBuffer,1);
        
        printf("Child leyo %c\n",readBuffer);
        }
        

    }
    else{

        close(fd[0]);
        write(fd[1],buffer,strlen(buffer)+1);
    }
    printf("QUien llego %d\n",getpid());
    return 0;
}
