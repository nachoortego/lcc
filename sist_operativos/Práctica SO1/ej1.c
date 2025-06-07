#include<stdio.h>
#include<unistd.h>
#include<sys/types.h>
#include<fcntl.h>
#include<sys/stat.h>

int main(){
    
    printf("El exec funcionó y mi pid es %d\n",getpid());
    return 0;

}