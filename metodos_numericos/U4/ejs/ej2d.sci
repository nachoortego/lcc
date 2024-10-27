function [x, a] = gausselim(A, b)
    // Verificar dimensiones
    [nA, mA] = size(A);
    [nb, mb] = size(b);

    if nA <> mA then
        error('gausselim - La matriz A debe ser cuadrada');
    elseif nb <> nA then
        error('gausselim - dimensiones incompatibles entre A y b');
    end;

    // Crear la matriz aumentada
    a = [A b];
    n = nA;

    // Eliminación progresiva
    for k = 1:n-1
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

// Ejemplos de aplicación
A = [3 -2 -1; 6 -2 2; -9 7 1]
b = [0 6 -1]'

A = [1 1 0 3; 2 1 -1 1; 3 -1 -1 2; -1 2 3 -1]
b = [4 1 -3 4]'

disp([A b])
[x,a] = gausselim(A,b)
disp(x)
disp(a)
