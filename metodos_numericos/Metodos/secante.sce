function y = f(x)
  x = 0:0.1:3; // Vector de valores desde 0 hasta 10 con incrementos de 0.1
  y = 2*sin(x)-x**2
  //plot(x,y)
  //xlabel("x"); // Etiqueta del eje x
  //ylabel("y"); // Etiqueta del eje y
  //title("Gráfico de y = 2*sin(x)-x**2"); // Título del gráfico
endfunction
  
function raiz = metodo_secante(fun, x0, x1, tolerancia, iter)
  deff("y=f(x)", "y=" + fun)
  i = 0
  raiz = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
  
  while abs(raiz - x1) > tolerancia && i <= iter
    i = i + 1
    x0 = x1
    x1 = raiz
    raiz = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
  end
  
  if abs(raiz - x1) > tolerancia then
    disp("Se alcanzo el maximo de iteraciones") 
  end

  disp(raiz)
  
endfunction
  
metodo_secante("2*sin(x)-x**2",-2,3,0.001,1000)
  
  
biseccion("2**x-2*x",1,1.5,0.001,100) // aplicar newton en este intervalo