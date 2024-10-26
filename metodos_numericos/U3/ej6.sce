function grafica()
  x = -5:0.001:5;
  clf;
  f = exp(x)./3;
  plot(x, f);
  plot(x, x);
endfunction

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
  if delta > tol
    disp("Se alcanzo la cantidad maxima de iteraciones")
  end

  disp(i)
  disp(x1)
  salida = x1
endfunction

funcprot(0)
grafica()
puntofijo("exp(x)/3", 1.513, 100, 0.0001)
