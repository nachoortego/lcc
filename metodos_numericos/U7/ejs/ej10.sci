clc
clear

// Polinomio de Chebyshev
function p = Cheby(n)
    x = poly(0,"x")
    if n==0
        p = 1
    elseif n==1
        p = x
    elseif n==2
        p = 2*x.^2-1
    else
        p = 2*x.*Cheby(n-1)-Cheby(n-2)
    end
endfunction

// Raíces del polinomio de Chebyshev
function w = roots_Cheby(n)
    // Entrada: n = grad del polinomio de Chebyshev
    // Salida: w = vector con las raices del polinomio de Chebyshev
    for i=0:(n-1)
        w(i+1)=cos((2*i+1)*%pi/(2*n))
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
function p = DD_Newton(x,y)
    r = poly(0,"x");
    p = 0;
    n= length(x);
    for i=n:(-1):2
        p = (p+DD(x(1:i),y(1:i)))*(r-x(i-1))
    end;
    p = p + y(1);
endfunction

// a)

w = roots_Cheby(4)
y = %e.^w
p = DD_Newton(w,y)

subplot(121)
xx = -1:0.01:1
plot2d(xx,[ %e.^xx' horner(p,xx') ], [2,5], leg="e^x@newton")
a = gca()
a.x_location = "origin"
a.y_location = "origin"


// b)

function e = err(p,x)
    e = %e.^x - horner(p,x)
endfunction

e = err(p,xx)

subplot(122)
plot2d(xx,[ e ], [3], leg="error")



