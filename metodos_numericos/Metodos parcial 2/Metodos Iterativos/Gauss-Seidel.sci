/// Gauss-Seidel
// xi^{k+1} = 1/aii (bi - sum_{j=1}^{i-1} aij xj^{k+1} 
//                      - sum_{j=i+1}^{n} aij xj^{k}
//                  )

function x = gauss(A,b,x0,eps,max_iter)
    n = size(A,1)
    x = x0
    xk = x
    cont = 0

    while (norm(x-xk) > eps || cont == 0) && cont < max_iter
        xk = x
        for i = 1:n
            suma = 0
            for j = 1:n
                if (i <> j)
                    suma = suma + A(i,j)*x(j)
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

x = gauss(B, b1, [0 0 0], 0.01,500)

disp(x)

disp(B * x')
