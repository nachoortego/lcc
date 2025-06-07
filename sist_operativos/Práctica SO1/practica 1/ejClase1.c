#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

void genRandArr(int n, int *randArr)
{
    int arr[n];  // Arreglo auxiliar con los valores ordenados

    // Llenar el arreglo con valores de 1 a n
    for (int i = 0; i < n; i++)
        arr[i] = i + 1;

    int max = n;  // Número de elementos válidos en arr[]

    for (int i = 0; i < n; i++)
    {
        int randPos = rand() % max;  // Generar índice aleatorio válido
        randArr[i] = arr[randPos];   // Elegir el número aleatorio

        // Eliminar el elemento de arr[] moviendo los restantes
        for (int j = randPos; j < max - 1; j++)
            arr[j] = arr[j + 1];

        max--;  // Reducir el rango del arreglo disponible
    }
}

int main(int argc, char **argv)
{
  srand(time(NULL));

  int n = atoi(argv[1]);

  int fd[2];

  pipe(fd);

  pid_t pid = fork();

  if (pid == 0)
  {
    int randArr[n];

    for (int i = 0; i < n; i++)
      read(fd[0], &randArr[i], sizeof(int));

    int h = n % 3, i = 0;
    for (i = 0; i < n - h; i = i + 3)
    {
      printf("%d %d %d\n", randArr[i], randArr[i + 1], randArr[i + 2]);
    }

    if (h == 1)
    {
      printf("%d\n", randArr[i]);
    }
    else if (h == 2)
    {
      printf("%d %d\n", randArr[i], randArr[i + 1]);
    }
  }
  else
  {

    int randArr[n];

    genRandArr(n, randArr);

    for (int i = 0; i < n; i++)
      write(fd[1], &randArr[i], sizeof(int));
  }
}