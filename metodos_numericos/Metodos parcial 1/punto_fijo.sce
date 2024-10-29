// CTD
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
  
// exec ("main.sce", -1)
puntofijo("cos(x)", 18, 100, 0.000001)
