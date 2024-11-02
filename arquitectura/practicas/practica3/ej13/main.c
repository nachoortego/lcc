#include <stdio.h>

unsigned long fact1(unsigned long);
unsigned long fact2(unsigned long);

int main(void)
{
  unsigned long x;
  scanf("%lu", &x);
  printf("fact1: %lu\n", fact1(x));
  printf("fact2: %lu\n", fact2(x));

  return 0;
}

// Ejecutar con
// $ gcc fact1.s fact2.s main.c