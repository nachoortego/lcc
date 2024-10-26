//f(x) = x**3 - x**2 + 2*x - 3
//f'(x) = 1 + c * (3*x**2 - 2*x + 2)

x = -5:0.1:5;
y = 1 + c*(3.*x.**2 - 2.*x + 2)
plot(x,y)
plot(x,x)

// Suponemos c>0
//f'(b) = |1 + c * f'(2)| < 1

//|1 + c * 10| < 1
//-1 < 1 + c * 10 < 1
//-2 < c * 10 < 0
//-1/5 < c < 0 ABS (c>0)

// Suponemos c<0
//f'(a) = |1 + c * f'(1)| < 1
//
//|1 + c * 3| < 1
//-1 < 1 + c * 3 < 1
//-2 < c * 3 < 0
//-2/3 < c < 0


function salida = puntofijo(fun, x0, iter, tol)
  deff("y=f(x)", "y="+fun)
  x1 = f(x0)
  delta = abs(x1 - x0)
  i = 1

  while delta > tol && i < iter
    x0 = x1
    x1 = f(x0)
    delta = abs(x1 - x0)
    i = i + 1
  end
  if delta > tol then
    disp("Se alcanzo la cantidad maxima de iteraciones")
  end
  disp("Resultado: " + string(x1))
  disp("Iteraciones: " + string(i))
  salida = x1
endfunction

puntofijo("x+(-1/2)*(x**3 - x**2 + 2*x - 3)", 1.5, 100, 0.0001)
