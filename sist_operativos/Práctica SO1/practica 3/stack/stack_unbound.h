#ifndef STACK_UNBOUND_H
#define STACK_UNBOUND_H

#include <stdlib.h>

// A structure to represent a stack
// here we use a linked list to represent the unbound stack
struct StackNode {
    int data;
    struct StackNode* next;
};

struct StackNode* newNode(int data);
 
int isEmpty(struct StackNode* root);
 
void push(struct StackNode** root, int data);
 
int pop(struct StackNode** root);
 
int top(struct StackNode* root);

void stackFree(struct StackNode* root);

#endif /* CONCURRENT_STACK_H */