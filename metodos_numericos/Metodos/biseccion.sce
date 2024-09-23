function y = f(x)
  x = 0:0.1:3; // Vector de valores desde 0 hasta 10 con incrementos de 0.1
  y = 2*sin(x)-x**2
  plot(x,y)
  xlabel("x"); // Etiqueta del eje x
  ylabel("y"); // Etiqueta del eje y
  title("Gráfico de y = 2*sin(x)-x**2"); // Título del gráfico
endfunction

function salida = biseccion(fun,a,b,tol,iter)
  deff("y=f(x)","y="+fun)

  for i = 0:iter
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
endfunction

f(1)
biseccion("2*sin(x)-x**2",0,3,0.001,100)