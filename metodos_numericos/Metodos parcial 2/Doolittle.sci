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
