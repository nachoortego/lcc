// Jacobi
// xi^{k+1} =
// 1 / aii (bi - sum_{j=1, j/=i}^{n} aij * xj^{k} )

function x = jacobi(A,b,x0,eps)
    n = size(A,1)
    x = x0
    xk = x
    cont = 0

    while norm(x-xk) > eps || cont == 0
        xk = x
        for i = 1:n
            suma = 0
            for j = 1:n
                if (j <> i)
                    suma = suma + A(i,j) * xk(j)
                end
            end
            x(i) = 1/A(i,i)*(b(i) - suma)
        end
        cont = cont + 1
    end
    disp(cont);
endfunction

A = [0 2  4  ;
     1 -1 -1 ;
     1 -1 2 ;]
     
 B = [1 -1  0  ;
     -1 2 -1 ;
     0 -1 1.1 ;]
     
b = [0 0.375 0]

b1 = [0 1 0]

x = jacobi(B, b1, [0 0 0], 0.01)

disp(x)

disp(B * x')
