// CTD
function salida = newton(fun,x0,tol,iter, h)
  deff("y=f(x)","y="+fun)
  i = 0;
  fx0 = f(x0)
  dfx0 = (f(x0 + h) - fx0) / h
  Ddfx0 = h/(f(x0+h) - fx0)
  x1 = x0 - fx0 * dfx0
  delta = abs(x1-x0)
  while delta > tol && i < iter
    i = i+1;
    x0 = x1
    fx0 = f(x0)
    dfx0 = f(x0 + h) - fx0
    x1 = x0 - f(x0) * h / dfx0
  end
  if(abs(x1 - x0) > tol) then
    disp("Se alcanzo el maximo de las iteraciones") 
  end
    disp(i)
    salida = x1;
  endfunction
  
  // newton("x**2-2", 1, 0.0001, 100)
  disp(newton("x**2-2", 1, 0.0001, 100, 0.000000001))
  // newton("cos(x)", 0, 0.0001, 100, 0.000000001)
  
  // exec ("main.sce", -1)
  // puntojijo("cos(x)", 18, 100, 0.000001)