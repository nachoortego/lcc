#ifndef CONCURRENT_STACK_H
#define CONCURRENT_STACK_H

#include <stdlib.h>
#include <pthread.h>
#include "stack_unbound.h"

struct ConcurrentStack{
    struct StackNode* stack;
    pthread_mutex_t mutex;
};

struct ConcurrentStack* new_cstack(); 
 
int c_isEmpty(struct ConcurrentStack* cstack);
 
void c_push(struct ConcurrentStack* cstack, int data);
 
int c_pop(struct ConcurrentStack* cstack);
 
int c_top(struct ConcurrentStack* cstack);

void c_stackFree(struct ConcurrentStack* cstack);

#endif /* CONCURRENT_STACK_H */