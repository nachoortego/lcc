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
    n= length(x);
    for i=n:(-1):2
        p = (p+DD(x(1:i),y(1:i)))*(r-x(i-1))
    end;
    p = p + y(1);
endfunction

x = [2.0 2.1 2.2 2.3 2.4 2.5]
y = [0.2239 0.1666 0.1104 0.0555 0.0025 -0.0484]

pol = DD_newton(x,y)

r1 = horner(pol,2.15)
r2 = horner(pol,2.35)

disp(r1,r2)
