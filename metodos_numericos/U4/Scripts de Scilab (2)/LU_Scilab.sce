clc
clear

// Utilizaremos la factorización LU de Scilab para resolver el sistema A*x=b

A = [0 2 3; 2 0 3; 8 16 -1]
b = [7 13 -3]'

[L,U,P] = lu(A)

disp(P)
disp(L)
disp(U)

// Modificamos el vector b usando la matriz de permutación
c = P*b

// La solución del sistema A*x=b mediante la factorización LU procede en dos etapas:
y = L\c
x = U\y

disp(x)
