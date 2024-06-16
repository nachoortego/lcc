#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

// Devolver el índice i en donde se encuentra el valor v, o −1 si no aparece en el array

int binsearch(int a[], int len, int v) {
  if (v > a[len-1] || v < a[0])
    return -1; // Si no esta en a[]

  int i = 0, f = len-1, medio;

  while(i <= f) {
    medio = (i + f) / 2;

    if(v == a[medio])
      return medio;

    if(v > a[medio])
      i = medio + 1;

    else
      f = medio - 1;
  }
  return -1;
}

void print(int a[], int len) {
  int i = 0;
  printf("[ ");
  for(; i < len-1; i++)
    printf("%d | ", a[i]);
  printf("%d ]\n", a[i]);
}

void insertion_sort(int* a, int len) {
  for(int i = 0; i < len; i++){
    int j = i;
    for(; j > 0 && a[j] < a[j-1];j--) {
      int temp = a[j];
      a[j] = a[j-1];
      a[j-1] = temp;
    }
  }
}

int* mezclar(int* a1, int* a2, int len1, int len2) {
  int i = 0, j = 0, k = 0;
  int newLen = len1 + len2;
  int* newArr = malloc(sizeof(int) * newLen);

  while(i < len1 && j < len2)
    newArr[k++] = a1[i] < a2[j] ? a1[i++] : a2[j++];

  while(i < len1)
    newArr[k++] = a1[i++];
  
  while(j < len2)
    newArr[k++] = a2[j++];

  return newArr;
}

int* merge_sort(int* arr, int len) {
  if(len < 2) {
    int* newArr = malloc(sizeof(int));
    *newArr = *arr;
    return newArr;
  }
  else {
    int medio = len/2;
    int* a1 = merge_sort(arr, medio);
    int* a2 = merge_sort(&arr[medio], len-medio);
    int* mezcla = mezclar(a1, a2, medio, len-medio);
    free(a1);
    free(a2);

    return mezcla;
  }
}

// Lomuto partition scheme
int lomuto_partition(int* a, int low, int high) {
    int pivot = a[high];
    int i = low;
    for (int j = low; j < high; j++) {
        if (a[j] <= pivot) {
            int temp = a[i];
            a[i] = a[j];
            a[j] = temp;
            i++;
        }
    }
    int temp = a[i];
    a[i] = a[high];
    a[high] = temp;
    return i;
}

// Quicksort function
void quicksort_r(int* a, int low, int high) {
    if (low < high) {
        int pi = lomuto_partition(a, low, high);
        quicksort_r(a, low, pi - 1);
        quicksort_r(a, pi + 1, high);
    }
}

void quicksort(int* a, int len){
  quicksort_r(a, 0, len-1);
}

int main() {
  int arr[] = { 4, 3, 5, 7, 2, 9, 1, 6, 8};

  print(arr, 9);
  // insertion_sort(arr, 9);
  // print(arr, 9);

  // int* sorted = merge_sort(arr, 9);
  // print(sorted, 9);
  
  quicksort(arr, 9);
  print(arr, 9);

  // free(sorted);

  return 0;
}