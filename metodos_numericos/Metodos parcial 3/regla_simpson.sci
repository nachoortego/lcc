function integral = reglaSimpson(fun, a, b)
    deff("y=f(x)","y=" + fun); // Define la funcion
    h = (b - a)/2
    integral = (h/3) * (f(a) + 4*f(a+h) + f(b))
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

integrate("x*sin(x)","x",0,2*%pi) // Para integrar en scilab

//err = (-((h^4) * (b-a)) / 180 ) * f''''(c) // 4ta derivada de f
