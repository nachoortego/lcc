// C program for linked list implementation of stack
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "stack_unbound.h"

// source: https://www.geeksforgeeks.org/stack-data-structure-introduction-program/
 
struct StackNode* newNode(int data)
{
    struct StackNode* stackNode = (struct StackNode*) malloc(sizeof(struct StackNode));
    stackNode->data = data;
    stackNode->next = NULL;
    return stackNode;
}
 
int isEmpty(struct StackNode* root)
{
    return !root;
}
 
void push(struct StackNode** root, int data)
{
    struct StackNode* stackNode = newNode(data);
    stackNode->next = *root;
    *root = stackNode;
}
 
int pop(struct StackNode** root)
{
    if (isEmpty(*root))
        return INT_MIN;
    struct StackNode* temp = *root;
    *root = (*root)->next;
    int popped = temp->data;
    free(temp);
 
    return popped;
}
 
int top(struct StackNode* root)
{
    if (isEmpty(root))
        return INT_MIN;
    return root->data;
}

void stackFree(struct StackNode* root)
{
  // we free the stack just popping all the elements
  while(!isEmpty(root))
  {
	  pop(&root);
  }
}
