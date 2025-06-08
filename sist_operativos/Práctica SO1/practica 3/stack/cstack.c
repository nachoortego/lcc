#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "cstack.h"

void concurrent_stack_init(struct ConcurrentStack* concurrentStack){
    concurrentStack->stack = NULL;
    pthread_mutex_init(&concurrentStack->mutex, NULL);
}

struct ConcurrentStack* new_cstack() {
    struct ConcurrentStack* cstack = (struct ConcurrentStack*) malloc(sizeof(struct ConcurrentStack));
    cstack->stack = NULL;
    pthread_mutex_init(&cstack->mutex, NULL);
    return cstack;
}
 
int c_isEmpty(struct ConcurrentStack* cstack)
{
    return !cstack->stack;
}
 
void c_push(struct ConcurrentStack* cstack, int data)
{
    pthread_mutex_lock(&cstack->mutex);
    push(&cstack->stack,data);
    pthread_mutex_unlock(&cstack->mutex);
}
 
int c_pop(struct ConcurrentStack* cstack)
{
    pthread_mutex_lock(&cstack->mutex);
    int popped = pop(&cstack->stack);
    pthread_mutex_unlock(&cstack->mutex);
    return popped;
}
 
int c_top(struct ConcurrentStack* cstack)
{
    pthread_mutex_lock(&cstack->mutex);
    int stack_top = top(cstack->stack);
    pthread_mutex_unlock(&cstack->mutex);
    return stack_top;
}

void c_stackFree(struct ConcurrentStack* cstack)
{
    pthread_mutex_lock(&cstack->mutex);
    stackFree(cstack->stack);
    pthread_mutex_unlock(&cstack->mutex);
}
