function integral = metodoTrapecioCompuesto(fun, a, b, n)
  deff("y=f(x)","y=" + fun) // Define la funcion
  h = (b - a) / n
  integral = 0
  xj = a

  for j = 0:n
      if j == 0 || j == n then
         integral = integral + 1/2 * f(xj)
      else
          integral = integral + f(xj)
      end
      xj = xj + h // Actualizamos el punto
  end
  integral = integral * h
endfunction

function integral = reglaSimpsonCompuesta(fun, a, b, n)
  deff("y=f(x)","y=" + fun) // Define la funcion
  h = (b - a)/n
  integral = 0
  xj = a

  for j = 0:n
      if j == 0 || j == n then
        integral = integral + f(xj)
      elseif (modulo(j,2) == 1) then
        integral = integral + 4 * f(xj)
      else
        integral = integral + 2 * f(xj)
      end
      xj = xj + h
  end
  integral = (h/3)*integral
endfunction


//a)
r1 = metodoTrapecioCompuesto("1/x",1,3,4)
r2 = reglaSimpsonCompuesta("1/x",1,3,4)
r3 = integrate("1/x","x",1,3)
disp("Trapecio: " + string(r1))
disp("Simpson: " + string(r2))
disp("Integrate: " + string(r3))
disp("Err trapecio: " + string(r1-r3))
disp("Err simpson: " + string(r2-r3))

//e)
r1 = metodoTrapecioCompuesto("x*sin(x)",0,2*%pi,8)
r2 = reglaSimpsonCompuesta("x*sin(x)",0,2*%pi,8)
r3 = integrate("x*sin(x)","x",0,2*%pi)
disp("Trapecio: " + string(r1))
disp("Simpson: " + string(r2))
disp("Integrate: " + string(r3))
disp("Err trapecio: " + string(r1-r3))
disp("Err simpson: " + string(r2-r3))

