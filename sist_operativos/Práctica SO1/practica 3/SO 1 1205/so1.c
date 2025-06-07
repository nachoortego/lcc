#include<unistd.h>
#include<stdio.h>

int main(){
    printf("pid: %d",getpid());
    const char* prog="./print_getpid";
    
    execl(prog,prog,NULL);
    return 0;
}
