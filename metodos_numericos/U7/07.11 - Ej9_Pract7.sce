// Ejercicio 9 de la Práctica 7
clc()
clear()

// Función error del ejercicio
function w = er(x,n)
    nodos = -5:10/n:5
    y = 1./(1.+nodos.^2)
    p = DD_Newton(nodos,y)
    w = 1./(1.+x.^2) - horner(p,x)
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

// - Ejercicio - //

xx = -5:0.01:5

n = 14 // grado
nodos = -5:10/n:5 // Nodos equiespaciados
y = 1./(1.+nodos.^2) // Vector de valores de y=1/(1+x^2) en los puntos xx
p = DD_Newton(nodos,y) // Polinomio de Newton de y=1/(1+x^2)
disp(p)

subplot(121)
plot2d(xx,[1./(1.+(xx').^2) horner(p,xx')],[2,3],leg="y=1/(1+x^2)@Newton (n=14)")
a=gca()
a.x_location = "origin"
a.y_location = "origin"
title("y=1/(1+x^2) vs Newton de grado 14")

subplot(122)
plot2d(xx,[er(xx,2)' er(xx,4)' er(xx,6)' er(xx,10)' er(xx,14)'],[2,3,4,5,6],leg="n=2@n=4@n=6@n=10@n=14")
a=gca()
a.x_location = "origin"
a.y_location = "origin"
title("Gráfica de la función error para valores distintos de n")


