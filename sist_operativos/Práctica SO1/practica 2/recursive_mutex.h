#ifndef __RECURSIVE_MUTEX_H__
#define __RECURSIVE_MUTEX_H__

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/types.h>
#include <errno.h>

typedef struct {
    pthread_mutex_t mut;
    size_t cont;
    pid_t callerId;
} _recinfo;

typedef _recinfo* recinfo;


recinfo mutexInitR();
 
void mutexLockR(recinfo r, pid_t id);


void mutexUnlockR(recinfo r, pid_t id);


#endif /* __RECURSIVE_MUTEX_H__ */
