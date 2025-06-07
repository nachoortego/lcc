#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

int denom = 0;
void handler(int s) { printf("ouch!\n"); denom = 1; }
int main() {
int r;
signal(SIGFPE, handler);
r = 1 / denom;
printf("r = %d\n", r);
return 0;
}

