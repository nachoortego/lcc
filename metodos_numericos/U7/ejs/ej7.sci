clc()
clear()

// Aproximación polinomial de mínimos cuadrados para matrices con rango completo
function [p,err] = MinCuad_pol(A,b)
    [a A_amp] = gausselimPP((A')*A,(A')*(b'))
    p = poly(a,"x","coeff")
    err = norm(A*a-(b'))
endfunction

// Matriz del métoodo de mínimo cuadrados polinomial
function A = A_mc(x,grado)
    // p = grado+1
    m = length(x)
    A = ones(m,1)
    for j=2:(grado+1)
        A = [A (x').^(j-1)]
    end
endfunction

// Métoodo de Eliminación Gaussiana con pivoteo parcial
function [x,a] = gausselimPP(A,b)
[nA,mA] = size(A) 
[nb,mb] = size(b)
a = [A b];
n = nA;

for k=1:n-1
    kpivot = k; amax = abs(a(k,k));
    for i=k+1:n
        if abs(a(i,k))>amax then
            kpivot = i; amax = a(i,k);
        end;
    end;
    temp = a(kpivot,:); a(kpivot,:) = a(k,:);
    a(k,:) = temp
    
    for i=k+1:n
        for j=k+1:n+1
            a(i,j) = a(i,j) - a(k,j)*a(i,k)/a(k,k)
        end;
        for j=1:k
            a(i,j) = 0;
        end
    end
end

x(n) = a(n,n+1)/a(n,n)

for i = n-1:-1:1
    sumk = 0
    for k=i+1:n
        sumk = sumk + a(i,k)*x(k)
    end
    x(i) = (a(i,n+1)-sumk)/a(i,i)
end

endfunction

x = [ 0 0.15 0.31 0.5 0.6 0.75 ]
y = [ 1 1.004 1.31 1.117 1.223 1.422 ]

// Grado 1
A = A_mc(x,1)
[p,err] = MinCuad_pol(A,y)
disp(err)
disp(p)

// Grado 2
A = A_mc(x,2)
[p,err] = MinCuad_pol(A,y)
disp(err)
disp(p)

// Grado 3
A = A_mc(x,3)
[p,err] = MinCuad_pol(A,y)
disp(err)
disp(p)



