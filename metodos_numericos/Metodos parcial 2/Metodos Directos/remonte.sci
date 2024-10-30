// Triangular superior
function s1 = remonte(A, b)
    n = size(A,1)
    x(n) = b(n)/A(n,n)
    for i = n-1:-1:1
        x(i) = (b(i) - A(i,i+1:n)*x(i+1:n)) / A(i,i)
    end
    s1 = x
endfunction


// Triangular inferior
function s1 = remonte_inf(A, b)
    n = size(A,1)
    x(1) = b(1)/A(1,1)
    for i = 2:n
        x(i) = (b(i) - A(i, 1:i-1) * x(1:i-1)) / A(i, i)
    end
    s1 = x
endfunction

