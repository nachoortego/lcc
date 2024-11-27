// Aproximación polinomial de mínimos cuadrados para matrices con rango completo
function [p,err] = MinCuad_pol(A,b)
    [a,A_amp] = gausselimPP((A')*A,(A')*(b'))
    p = poly(a,"x","coeff")
    err = norm(A*a-(b'))
endfunction

// Matriz del métoodo de mínimo cuadrados polinomial
function A = A_mc(x,grado)
    // p = grado+1
    m = length(x)
    A = ones(m,1)
    for j=2:(grado+1)
        A = [A,(x').^(j-1)]
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

// Diferencias dividas

function w=DD(x,y)
    n = length(x);
    if n==1 then
        w = y(1)
    else
        w = (DD(x(2:n),y(2:n))-DD(x(1:n-1),y(1:n-1)))/(x(n)-x(1))
    end;
endfunction

// Polinomio interpolante (con Newton)

function p = DD_newton(x,y)
    r = poly(0,"x");
    p = 0;
    n = length(x);
    for i=n:(-1):2
        p = (p + DD(x(1:i),y(1:i))) * (r-x(i-1))
    end;
    p = p + y(1);
endfunction


x2=[0,0.2,0.4,0.6]
y2=[1,1.2214,1.4918,1.8221]

cubica = DD_newton(x2,y2)
A = A_mc(x2,4)
min_cuad = MinCuad_pol(A,y2)
rango = [-2:0.01:2]

plot2d(rango,horner(cubica,rango),[2])
plot2d(rango,exp(rango),[3])
plot2d(rango,horner(min_cuad,rango),[5])
a=gca();
a.x_location = "origin";
a.y_location = "origin";
h1 = legend("Cubico","e^x","min cuad")

// Definir el punto donde queremos evaluar
x_eval = 1/3; // Raíz cúbica de e se evalúa en x = 1/3

// Evaluar el polinomio interpolante cúbico
valor_cubico = horner(cubica, x_eval);

// Mostrar los resultados
disp("Valor interpolado cúbico en 1/3:");
disp(valor_cubico);
