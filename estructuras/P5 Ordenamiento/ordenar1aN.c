#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <string.h>

// Toma de la entrada estandar numeros separados por espacios
// y lo convierte a un arreglo de enteros. Almacena en n su longitud
// NO verifica que la entrada sea correcta (es decir, no verifica que
// no haya numeros repetidos ni que respeten los rangos del problema).
int* generar_prueba(int *n) {
  char buf[256], *tok, *start;
  unsigned size = 50;
  unsigned len = 0;

  int *a = malloc(sizeof(int) * size);
  assert(a != NULL);

  printf("a: ");
  fgets(buf, 256, stdin);

  char *start = buf;
  char *tok = strtok(start, " \n");
  while (tok != NULL) {
    if (len == size) {
      size *= 2;
      a = realloc(a, sizeof(int) * size);
      assert(a != NULL);
    }
    a[len++] = atoi(tok);
    tok = strtok(NULL, " \n");
  }

  *n = len;
  a = realloc(a, sizeof(int) * len);
  return a;
}

void print_array(int *a, unsigned len) {
  for (unsigned i = 0; i < len; i++)
    printf("%d ", a[i]);
  putchar('\n');
}

int sum_array(int *a, unsigned len) {
  int sum = 0;
  for (unsigned i = 0; i < len; i++)
	sum += a[i];
  return sum;
}

int encontrar_faltante(int *a, unsigned n) {
  int suma, suma_1aN;
  suma = sum_array(a, n - 1);
  suma_1aN = (n * (n + 1)) / 2;
  return suma_1aN - suma;
}

/* Escribe en a los enteros ordenados del 1 al N, sin el x
   Por ejemplo, escribir_ordenado(4, a, 6) escribe en a la secuencia
   {1, 2, 3, 5, 6}
   Esto es equivalente a decir que:
   * Para los indices 0 < i < x-1 vale a[i] = i+1
   * Para los indices x-1 <= i < N-1 vale a[i] = i+2
*/
void escribir_ordenado(int x, int *a, int N) {
  assert(1 <= N);
  assert(0 < x && x <= N);
  for (int i = 0; i < x-1; i++)
    a[i] = i+1;

  for (int i = x-1; i < N-1; i++)
    a[i] = i+2;
}

/* Ordena un arreglo de (N - 1) enteros del 1 al N sin repetir. */
void ordenar_enteros(int *a, unsigned N) {
  int faltante = encontrar_faltante(a, N);
  escribir_ordenado(faltante, a, N);
}

int main() {
  int len;
  int *a;
  while (1) {
    a = generar_prueba(&len);
    ordenar_enteros(a, len+1); // Pasamos len+1 porque ordenar_enteros recibe el N del problema
    printf("sorted a: ");
    print_array(a, len);
    free(a);
    getchar();
  }
  return 0;
}

