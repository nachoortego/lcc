function [x,a] = gausselimPP(A,b)
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

// Eliminación progresiva con pivoteo parcial
for k=1:n-1
    kpivot = k;
	amax = abs(a(k,k));  //pivoteo
    for i=k+1:n
        if abs(a(i,k))>amax then
            kpivot = i; amax = a(i,k);
        end;
    end;
    temp = a(kpivot,:); // cambio de filas
	a(kpivot,:) = a(k,:); 
	a(k,:) = temp;
    
	// Eliminacion progresiva
    a(k+1:n, k+1:n+1) = a(k+1:n, k+1:n+1) - a(k+1:n, k) * a(k, k+1:n+1) / a(k, k);
	a(k+1:n,1:k) = 0
end;

// Sustitución regresiva
//    x = zeros(n, 1);
    x(n) = a(n, n+1) / a(n, n);
    for i = n-1:-1:1
        x(i) = (a(i, n+1) - a(i, i+1:n) * x(i+1:n)) / a(i, i);
    end;
endfunction

// Ejemplo de aplicación
A2 = [0 2 3; 2 0 3; 8 16 -1]
b2 = [7 13 -3]'

disp([A2 b2])
[x2,a2] = gausselimPP(A2,b2)
disp(x2)
disp(a2)
