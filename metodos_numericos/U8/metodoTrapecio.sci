function integral = metodoTrapecio(fun, a, b)
    deff("y=f(x)","y=" + fun) // Define la funcion
    h = b - a
    integral = (h/2) * (f(a) + f(b))
endfunction


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
