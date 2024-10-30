function [Q, R] = qrFactorization(A)
    [m, n] = size(A);  
    Q = zeros(m, n);
    R = zeros(n, n);

    for k = 1:n
        v = A(:, k)

        for i = 1:k-1
            R(i, k) = Q(:, i)' * A(:, k);
            v = v - R(i, k) * Q(:, i); 
        end

        R(k, k) = norm(v);
        Q(:, k) = v / R(k, k);
    end
endfunction
