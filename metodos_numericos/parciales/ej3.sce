function salida = biseccion(fun,a,b,tol,iter)
  deff("y=f(x)","y="+fun)

  for i = 1:iter
    c = (a + b) / 2
    if (b - c) <= tol then
      salida = c
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
  salida = c
endfunction

biseccion("x**4-x**2+2*x-1",0,1,1e-6,100)

disp(1e-6)
