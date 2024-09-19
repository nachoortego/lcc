function salida = falsa_posicion(fun,a,b,tol,iter)
  deff("y=f(x)","y="+fun)

  for i = 0:iter
    a1 = a
    b1 = b

    for j = 0:iter
      c = (a + b) / 2
      if (b - c) <= tol then
        break
      else
        if f(b) * f(c) < 0 then
          a = c
        else
          b = c
        end
      end
    end

    if f(a)*f(c) < 0 then
      a = a1
      b = c
    elseif f(b)*f(c) < 0 then
      a = c
      b = b1
    else
      salida = c
      break
    end
  end
  
endfunction