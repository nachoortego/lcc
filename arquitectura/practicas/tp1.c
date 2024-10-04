#include <stdio.h>

int is_one(long n, int b) {
  return (n >> b) & 1; // Desplaza n ’b ’ veces hacia la derecha
}

void printbin(unsigned long n) {
  for (int i = 31; i >= 0; i--) // Recorre cada bit y lo muestra
    printf ((i%8 == 0) ? "%d " : "%d", is_one (n, i)); // Muestra un espacio cada 8 bits
}

int main() {
  int nums[6] = { -16, 13, -1, -10, 16, -31 };

  for(int i = 0; i < 6; i++) {
    printbin(nums[i]);
    printf("%8d\n", nums[i]);
  }

  return 0;
}