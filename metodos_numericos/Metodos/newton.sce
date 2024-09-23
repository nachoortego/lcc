// CTD

function salida = newton_v1(fun,x0,tol,iter)
  deff("y=f(x)","y="+fun)
  i = 0;
  x1 = x0 - f(x0) / numderivative(f, x0)

  while abs(x1 - x0) > tol && i < iter
    i = i+1;
    x0 = x1
    x1 = x0 - f(x0) / numderivative(f,x0)
  end 

  if(abs(x1 - x0) > tol) then 
    disp("Se alcanzo el maximo de las iteraciones") 
  end

  disp(i)
  disp(x1)
  salida = x1;
endfunction
  

function salida = newton(fun,x0,tol,iter, h)
  deff("y=f(x)","y="+fun)
  i = 0;
  fx0 = f(x0)
  dfx0 = (f(x0 + h) - fx0) / h
  x1 = x0 - fx0 / dfx0

  while abs(x1 - x0) > tol && i < iter
    i = i+1;
    x0 = x1
    fx0 = f(x0)
    dfx0 = (f(x0 + h) - fx0) / h
    x1 = x0 - f(x0) / dfx0
  end

  if(abs(x1 - x0) > tol) then 
    disp("Se alcanzo el maximo de las iteraciones") 
  end

  disp(i)
  disp(x1)
  salida = x1;
endfunction

newton_v1("x**2-2", 1, 0.00001, 100)
newton("x**2-2", 1, 0.00001, 100, 0.000000001)
