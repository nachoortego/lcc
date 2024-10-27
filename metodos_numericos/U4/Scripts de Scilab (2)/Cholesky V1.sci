clc
function [U, ind] = Cholesky(A)
eps = 1.0e-8
n = size(A,1)
U = zeros(n,n)
for k = 1:n
    if k==1 then
    	t = A(k,k)
    else 
        t = A(k,k) - U(1:k-1,k)'*U(1:k-1,k)
    end

    if t <= eps
        printf("Matriz no definida positiva.\n")
        ind = 0
        return
    end
    U(k,k)= sqrt(t)
    for j = k+1:n
        if k==1 
            U(k,j) = A(k,j)/U(k,k)
        else 
            U(k,j) = ( A(k,j) - U(1:k-1,k)' * U(1:k-1,j) )/U(k,k)
        end
    end
end
ind = 1
endfunction

A = [4 1 1; 1 2 2; 1 2 3]

disp(A)
printf("\n")
[U,ind] = Cholesky(A)
disp(U)
disp(ind)
