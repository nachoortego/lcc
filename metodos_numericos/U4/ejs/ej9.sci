clc

function [x,a,P] = gausselimPP(A,b)
// Esta función obtiene la solución del sistema de ecuaciones lineales A*x=b, 
// dada la matriz de coeficientes A y el vector b.
// La función implementa el métod de Eliminación Gaussiana con pivoteo parcial.

[nA,mA] = size(A)
[nb,mb] = size(b)

if nA<>mA then
    error('gausselim - La matriz A debe ser cuadrada');
    abort;
elseif mA<>nb then
    error('gausselim - dimensiones incompatibles entre A y b');
    abort;
end;

a = [A b]; // Matriz aumentada
n = nA;    // Tamaño de la matriz
P = eye(n,n) // Matriz de permutacion

// Eliminación progresiva con pivoteo parcial
for k=1:n-1
    kpivot = k;
	amax = abs(a(k,k));  //pivoteo
    for i=k+1:n
        if abs(a(i,k))>amax then
            kpivot = i; amax = a(i,k);
        end;
    end;
    temp = a(kpivot,:); // cambio de filas matriz A
	a(kpivot,:) = a(k,:); 
	a(k,:) = temp;
    
    temp = P(kpivot,:); // cambio de filas matriz P
	P(kpivot,:) = P(k,:); 
	P(k,:) = temp;

    a(k+1:n, k+1:n+1) = a(k+1:n, k+1:n+1) - a(k+1:n, k) * a(k, k+1:n+1) / a(k, k);
	a(k+1:n,1:k) = 0
end;

// Sustitución regresiva
    x = zeros(n, 1);
    x(n) = a(n, n+1) / a(n, n);
    for i = n-1:-1:1
        x(i) = (a(i, n+1) - a(i, i+1:n) * x(i+1:n)) / a(i, i);
    end;
endfunction

// A

A = [	1 2 -2 1
		4 5 -7 6
		5 25 -15 -3
		6 -12 -6 22]

b = [ 
1
2
0
1 ]


[x , a , P ] = gausselimPP(A,b)

disp(a)
disp(x)
disp(P)

// B
// PA = LU
// Tenemos P, A y hay que sacarle la columna n+1 a 'a' para tener U

n = size(a,1)
U = a(:,1:n) 
disp("U:")
disp(U)

L = (P*A) / U
for k = 1:n
	L(1:k,k+1:n) = 0 // llenamos de 0 por error de precision
end

disp("L:")
disp(L)

// resolucion sistema:

c = P*b
y = L\c
x = U\y

disp(x)


