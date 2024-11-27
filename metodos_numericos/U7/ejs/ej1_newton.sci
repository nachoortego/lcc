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
rango = [-2:0.01:2]

plot(rango,horner(cubica,rango),"b")
plot(rango,exp(rango),"g")
a=gca();
a.x_location = "origin";
a.y_location = "origin";
h1 = legend("Cubico","e^x")

// Definir el punto donde queremos evaluar
x_eval = 1/3; // Raíz cúbica de e se evalúa en x = 1/3

// Evaluar el polinomio interpolante cúbico
valor_cubico = horner(cubica, x_eval);

// Mostrar los resultados
disp("Valor interpolado cúbico en 1/3:");
disp(valor_cubico);

