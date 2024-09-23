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
puntofijo("x + 0.4*(x**2-5)", 1, 100, 0.0001)
