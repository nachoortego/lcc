clc

function A = ej_a(c,N)
	A = eye(N,N) + 2*c*eye(N,N) + -c*diag(ones(N-1,1),1) + -c*diag(ones(N-1,1),-1)
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

function x = dist_temp(A,x0,n)
	[L,U] = doolittle(ej_a(1,5))
	for i = 1:n
		y = L\x0
		x = U\y
		x0 = x
	end
endfunction

A = ej_a(1,5)
disp(dist_temp(A,[10 12 12 12 10]',1))

