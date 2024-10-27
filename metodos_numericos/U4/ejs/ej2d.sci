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
    n = nA;  // Tamaño de la matriz cuadrada
    count = 0; // Contador de operaciones

    // Eliminación progresiva
    for k = 1:n-1
        // Actualizar las filas inferiores en bloque usando submatrices
        a(k+1:n, k+1:n+1) = a(k+1:n, k+1:n+1) - a(k+1:n, k) * a(k, k+1:n+1) / a(k, k);
        count = count + (n - k) * (n - k + 1);  // Contar operaciones
    end;

    // Sustitución regresiva para resolver el sistema
    x = zeros(n, 1);  // Inicialización del vector solución
    x(n) = a(n, n+1) / a(n, n);
    for i = n-1:-1:1
        x(i) = (a(i, n+1) - a(i, i+1:n) * x(i+1:n)) / a(i, i);
        count = count + (n - i);
    end;

    printf("Operaciones: %d \n", count);
endfunction
