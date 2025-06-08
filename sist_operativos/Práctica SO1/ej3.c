#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>
#include<fcntl.h>
#include<sys/stat.h>

int main(){
    char path[] = "repetir";
    pid_t pid=fork();
    if(pid==0){
        execl("./repetir","./repetir",NULL);
    }
    else{
        sleep(0.5);
    }
    return 0;               
}
