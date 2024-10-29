




function x = SOR(A,b,x0,iter,tol,w)
    n = size(A,1)
    x = x0
    x0(1) = (1-w)*x0(1)+w*(b(1)-A(1,2:n)*x0(2:n))/A(1,1)
    for i=2:(n-1)
        x0(i) = (1-w)*x0(i)+w*(b(i)-A(i,1:i-1)*x0(1:i-1)-A(i,i+1:n)*x0(i+1:n))/A(i,i)
    end
    x0(n) = (1-w)*x0(n)+w*(b(n)-A(n,1:n-1)*x0(1:n-1))/A(n,n)
    it = 1
    err = norm(x0-x)
    
    while (err>tol)&&(it<iter)
        x = x0
        x0(1) = (1-w)*x0(1)+w*(b(1)-A(1,2:n)*x0(2:n))/A(1,1)
        for i=2:(n-1)
            x0(i) = (1-w)*x0(i)+w*(b(i)-A(i,1:i-1)*x0(1:i-1)-A(i,i+1:n)*x0(i+1:n))/A(i,i)
        end
        x0(n) = (1-w)*x0(n)+w*(b(n)-A(n,1:n-1)*x0(1:n-1))/A(n,n)
        it = it + 1
        err = norm(x0-x)
    end
endfunction

function w=omega_opt(A)
    // A es una matriz definida positiva y tridiagonal
    n = size(A)(1)
    T_j = eye(n,n)-diag(1./diag(A))*A
    autovalores = spec(T_j)
    rho = max(abs(autovalores)) // ver help eigs
    w = 2/(1+sqrt(1-rho**2))
endfunction
