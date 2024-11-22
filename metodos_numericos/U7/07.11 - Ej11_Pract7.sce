// Ejercicio 11 de la Práctica 7
clc()
clear()

// Raíces del polinomio de Chebyshev
function w = roots_Cheby(n)
    // Entrada: n = grad del polinomio de Chebyshev
    // Salida: w = vector con las raices del polinomio de Chebyshev
    for i=0:(n-1) do
        w(i+1)=cos((2*i+1)*%pi/(2*n))
    end
endfunction

// Raíces del polinomio de Chebyshev
function w = roots_Cheby_ab(n,a,b)
    for i=0:(n-1) do
        w(i+1)=cos((2*i+1)*%pi/(2*n))
    end
    w = ((b-a)*w + (b+a))/2
endfunction

// Polinomio de Chebyshev
function w = Cheby(x,n)
    // Entrada: n = número natural; x = número real
    // Salida: Polinomio de Chebyshev de grado n evaluado en x
    if n==0 then
        w = 1
    elseif n==1 then
        w = x
    elseif n==2 then
        w = 2*x.^2-1
    else
        w = 2*x.*Cheby(x,n-1)-Cheby(x,n-2)
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

// - Ejercicio 11 - //

n= 10 // grado
nodos_cheby = roots_Cheby_ab(n+1,0,%pi/2) // nodos = grado + 1
nodos_equidist = 0:%pi/(2*n):%pi/2

p_cheby = DD_Newton(nodos_cheby,cos(nodos_cheby))
p_equidist = DD_Newton(nodos_equidist,cos(nodos_equidist))


xx = 0:0.01:(%pi/2)

er_cheby = cos(xx) - horner(p_cheby,xx)
er_equidist = cos(xx) - horner(p_equidist,xx)
plot2d(xx,[er_cheby' er_equidist'], leg="Cheby@equidist")
a=gca()
a.x_location = "origin"
a.y_location = "origin"


