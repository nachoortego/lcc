#include "recursive_mutex.h"

recinfo mutexInitR() {
    recinfo r = malloc(sizeof(_recinfo));
    
    //Has to be initialized this way, we can't use the macro directly.
    pthread_mutex_t mut = PTHREAD_MUTEX_INITIALIZER;
    r->mut = mut;

    r->cont = 0;
    //We initialize the ID to -1 since no thread can have a negative ID.
    r->callerId = -1;
    return r;
}
 
void mutexLockR(recinfo r, pid_t id) {
    if (!pthread_mutex_trylock(&(r->mut))) {
        r->callerId = id;
        //Reset lock counter.
        r->cont = 1;
    }
    else {
        if (r->callerId == id)
            //There should be an overflow check.
            r->cont = r->cont + 1;
        else {
            //Lock and wait
            pthread_mutex_lock(&(r->mut));
            //This is to allow the recursive call to "lockR" to obtain a lock.
            pthread_mutex_unlock(&(r->mut));
            mutexLockR(r, id);
        }
    }
}


void mutexUnlockR(recinfo r, pid_t id) {
    if (r->callerId == id && r->cont > 0) {
        r->cont = r->cont - 1;

        if (r->cont == 0)
            pthread_mutex_unlock(&(r->mut));
    }
}