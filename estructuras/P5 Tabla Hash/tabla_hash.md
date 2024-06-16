
# Inserción en Tabla Hash

Considere una tabla hash con capacidad para 11 elementos inicialmente vacía. Usando la función
de hash `f(x) = x mod 11` y linear probing para resolver colisiones, dibuje el resultado de insertar en la
tabla la siguiente secuencia de números:
10, 20, 15, 25, 30, 3, 18, 19.

## Paso 1: Insertar 10
- `f(10) = 10 mod 11 = 10`
- Insertamos 10 en la posición 10.

| Index | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 |
|-------|----|----|----|----|----|----|----|----|----|----|----|
| Value |    |    |    |    |    |    |    |    |    |    | 10 |

## Paso 2: Insertar 20
- `f(20) = 20 mod 11 = 9`
- Insertamos 20 en la posición 9.

| Index | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 |
|-------|----|----|----|----|----|----|----|----|----|----|----|
| Value |    |    |    |    |    |    |    |    |    | 20 | 10 |

## Paso 3: Insertar 15
- `f(15) = 15 mod 11 = 4`
- Insertamos 15 en la posición 4.

| Index | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 |
|-------|----|----|----|----|----|----|----|----|----|----|----|
| Value |    |    |    |    | 15 |    |    |    |    | 20 | 10 |

## Paso 4: Insertar 25
- `f(25) = 25 mod 11 = 3`
- Insertamos 25 en la posición 3.

| Index | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 |
|-------|----|----|----|----|----|----|----|----|----|----|----|
| Value |    |    |    | 25 | 15 |    |    |    |    | 20 | 10 |

## Paso 5: Insertar 30
- `f(30) = 30 mod 11 = 8`
- Insertamos 30 en la posición 8.

| Index | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 |
|-------|----|----|----|----|----|----|----|----|----|----|----|
| Value |    |    |    | 25 | 15 |    |    |    | 30 | 20 | 10 |

## Paso 6: Insertar 3
- `f(3) = 3 mod 11 = 3`
- La posición 3 está ocupada, entonces aplicamos linear probing.
- La siguiente posición libre es la 5.
- Insertamos 3 en la posición 5.

| Index | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 |
|-------|----|----|----|----|----|----|----|----|----|----|----|
| Value |    |    |    | 25 | 15 |  3 |    |    | 30 | 20 | 10 |

## Paso 7: Insertar 18j
- `f(18) = 18 mod 11 = 7`
- Insertamos 18 en la posición 7.

| Index | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 |
|-------|----|----|----|----|----|----|----|----|----|----|----|
| Value |    |    |    | 25 | 15 |  3 |    | 18 | 30 | 20 | 10 |

## Paso 8: Insertar 19
- `f(19) = 19 mod 11 = 8`
- La posición 8 está ocupada, entonces aplicamos linear probing hacia adelante.
- Verificamos la siguiente posición: 9 (ocupada por 20).
- Verificamos la siguiente posición: 10 (ocupada por 10).
- Verificamos la siguiente posición: 0 (libre).
- Insertamos 19 en la posición 0.

## Tabla final corregida
La tabla hash final después de insertar todos los elementos es la siguiente:

| Index | 0  | 1  | 2  | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 |
|-------|----|----|----|----|----|----|----|----|----|----|----|
| Value | 19 |    |    | 25 | 15 |  3 |    | 18 | 30 | 20 | 10 |
