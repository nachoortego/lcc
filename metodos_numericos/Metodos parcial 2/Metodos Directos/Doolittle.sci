function [L, U] = dolittleLU(A)
	n = size(A,1)
    L = eye(n, n)
    U = A

    for k = 1:n-1
        for i = k+1:n
            L(i, k) = U(i, k) / U(k, k)
            U(i, :) = U(i, :) - L(i, k) * U(k, :)
        end
    end
endfunction

function [L, U] = doolittle(A)
    n = size(A,1);
    L = eye(n, n);
    U = zeros(n, n);

    U(1,:)= A(1,:) // Primera fila de U
    L(:,1)= A(:,1)/ U(1,1) // Primera columna de L

    for i = 2:n
        // Calcula los elementos de U
        sumU = L(i, 1:i-1) * U(1:i-1, i:n);
        U(i, i:n) = A(i, i:n) - sumU;

        // Calcula los elementos de L
        sumL = L(i+1:n, 1:i-1) * U(1:i-1, i);
        L(i+1:n, i) = (A(i+1:n, i) - sumL) / U(i, i);
    end
end

// Ejemplo de uso
A = [2 -1 1; 3 3 9; 3 3 5];
[L, U] = doolittle(A);

disp(L, "Matriz L:");
disp(U, "Matriz U:");
