function x = jacobi(A,b,x0,eps)
    n = size(A,1)
    x = x0
    xk = x
    cont = 0
    
    while (norm(x-xk) > eps || cont == 0 ) // sacar abs, norm > 0
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

A = [10 1 2 3 4
    1 9 -1 2 -3
    2 -1 7 3 -5
    3 2 3 12 -1
    4 -3 -5 -1 15]
    
b = [12
    -27
    14
    -17
    12]
    
x = jacobi(A, b, [0 0 0 0 0], 0.000001)

disp(x)

function x = gauss(A,b,x0,eps)
    n = size(A,1);
    x = x0;
    xk = x;
    suma = 0;
    cont = 0;

    while (abs(norm(x-xk))> eps || cont == 0)
        xk = x
        for i=1:n
            suma = 0
            for j = 1:n
                if (i<>j)
                    suma = suma + A(i,j)*x(j)
                end
            end
            x(i) = 1/A(i,i)*(b(i)-suma)
        end
     cont = cont+1
    end
    disp(cont);
endfunction

x = gauss(A, b, [0 0 0 0 0], 0.000001)

disp(x)







