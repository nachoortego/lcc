#ifndef BARRIER_H
#define BARRIER_H

#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

struct barrier;

void barrier_init(struct barrier *b, int n);
void barrier_wait(struct barrier *b);
void barrier_destroy(struct barrier *b);

#endif // BARRIER_H
