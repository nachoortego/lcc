function [x,a] = gausselim(A,b)
// Esta función obtiene la solución del sistema de ecuaciones lineales A*x=b, 
// dada la matriz de coeficientes A y el vector b.
// La función implementa el metod de Eliminación Gaussiana sin pivoteo.

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
count = 0
// Eliminación progresiva
n = nA;
for k = 1:n-1
	a(k+1:n, k+1:n+1) = a(k+1:n, k+1:n+1) - a(k+1:n, k) * a(k, k+1:n+1) / a(k, k);
	a(k+1:n,1:k) = 0
end;


// Sustitución regresiva
x(n) = a(n,n+1)/a(n,n);
for i = n-1:-1:1
    sumk = 0
    for k=i+1:n
        sumk = sumk + a(i,k)*x(k);
        count = count + 1
    end;
    x(i) = (a(i,n+1)-sumk)/a(i,i);
end;

printf("Operaciones: %d \n", count)
endfunction

// Ejemplos de aplicación
A = [3 -2 -1; 6 -2 2; -9 7 1]
b = [0 6 -1]'

A = [1 1 0 3; 2 1 -1 1; 3 -1 -1 2; -1 2 3 -1]
b = [4 1 -3 4]'

disp([A b])
[x,a] = gausselim(A,b)
disp(x)
disp(a)

A2 = [0 2 3; 2 0 3; 8 16 -1]
b2 = [7 13 -3]'

A2 = [1 -1 2 -1; 2 -2 3 -3; 1 1 1 0; 1 -1 4 3]
b2 = [-8 -20 -2 4]'

[x2,a2] = gausselim(A2,b2)
//disp(x2)
//disp(a2)

// !--error 27 
//Division by zero...
//at line      24 of function gausselim called by :  
//[x2,a2] = gausselim(A2,b2)


