#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

void print(int a[], int len) {
  int i = 0;
  printf("[ ");
  for(; i < len-1; i++)
    printf("%d | ", a[i]);
  printf("%d ]\n", a[i]);
}

void swap(int* x, int* y) {
  int temp = *x;
  *x = *y;
  *y = temp;
}

int izq(int i) {
  return i*2+1;
}

int der(int i) {
  return i*2+2;
}

void hundir(int pos, int* arr, int n) {
  int max_pos = pos;
  if (izq(pos) < n && arr[izq(pos)] > arr[max_pos]) 
    max_pos = izq(pos);
  if (der(pos) < n && arr[der(pos)] > arr[max_pos]) 
    max_pos = der(pos);
  if (max_pos != pos) {
    swap(&arr[pos], &arr[max_pos]);
    hundir(max_pos, arr, n);
  }
}

void heapify(int* arr, int n) {
  // Comenzar desde el último nodo no hoja y aplicar la función hundir
  for(int i = (n / 2) - 1; i >= 0; i--)
    hundir(i, arr, n);
}

void sort(int* arr, int n) {
  // Construir el heap
  heapify(arr, n);
  // Extraer elementos del heap uno por uno
  for (int i = n - 1; i > 0; i--) {
    // Mover el nodo raíz actual al final
    swap(&arr[0], &arr[i]);
    // Llamar a hundir en el heap reducido
    hundir(0, arr, i);
  }
}

int main() {
  int arr[] = { 4, 3, 5, 7, 2, 9, 1, 6, 8};
  print(arr,9);
  heapify(arr,9);
  print(arr,9);
  sort(arr,9);
  print(arr,9);

  return 0;
}