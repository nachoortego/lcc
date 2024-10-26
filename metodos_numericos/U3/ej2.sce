function f()
  x = -2:0.1:2; // Vector de valores desde 0 hasta 10 con incrementos de 0.1
  clf;  // Limpiar la ventana de gráficos
  f = exp(-x) - x.^4;
  plot(x, f);
  xlabel("x");
  ylabel("f(x) = e^{-x} - x^4");
  title("Gráfica de f(x) = e^{-x} - x^4");
endfunction

function salida = biseccion(fun,a,b,tol,iter)
  deff("y=f(x)","y="+fun)

  for i = 0:iter
    c = (a + b) / 2
    if (b - c) <= tol then
      salida = c
      disp(c)
      break
    else
      if f(b) * f(c) < 0 then
        a = c
      else
        b = c
      end
    end  
  end
  disp("Cantidad de iteraciones: " + string(i))
  disp("Resultado: " + string(c))
endfunction

function raiz = metodo_secante(fun, x0, x1, tolerancia, iter)
  deff("y=f(x)", "y=" + fun)
  i = 0
  raiz = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
  
  while abs(raiz - x1) > tolerancia && i < iter
    i = i + 1
    x0 = x1
    x1 = raiz
    raiz = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
  end
  
  if abs(raiz - x1) > tolerancia then
    disp("Se alcanzo el maximo de iteraciones") 
  end

  disp("Cantidad de iteraciones: " + string(i))
  disp("Resultado: " + string(raiz))
endfunction

f()
disp("Biseccion")
biseccion("exp(-x) - x.^4",-2,0,0.000001,100)
disp("Secante")
metodo_secante("exp(-x) - x.^4",-2,-1,0.000001,100)
