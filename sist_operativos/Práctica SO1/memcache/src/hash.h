#ifndef __HASH_H
#define __HASH_H 1

#include "common.h"

typedef unsigned long u64;

u64 hash_buf(int klen, const char *k);

#endif
