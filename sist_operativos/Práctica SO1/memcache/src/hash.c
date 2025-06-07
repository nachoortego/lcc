#include "hash.h"

STATIC_ASSERT(sizeof (u64) == 8);

u64 hash_buf(int klen, const char *k)
{
	u64 r = 0;
	int i;

	for (i = 0; i < klen; i++)
		r = 251*r + (unsigned char)k[i];

	return r;
}
