#include<stdio.h>
#include<unistd.h>

int main(){
    printf("pid: %d\n",getpid());
    const char* prog="./ejemplo";
    execl(prog,prog,NULL);
    printf("pid: %d\n",getpid());
    return 0;
}
