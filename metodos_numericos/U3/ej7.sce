function y = newton_multivariable(f, x0, tol, iter)
  J = inv(numderivative(f, x0)) // La inversa de la jacobiana de f(x)
  x1 = x0 - J * f(x0)
  i = 0

  while norm(f(x1)) > tol && i < iter
    i = i + 1
    x0 = x1
    J = inv(numderivative(f, x0))
    x1 = x0 - J * f(x0);
  end

  disp(i)
  disp(x1)
  y = x1
endfunction

// Sistema de ecuaciones no lineales
function F = fun(v)
    x = v(1);
    y = v(2);
    F = [1 + x^2 - y^2 + (%e^x)*cos(y) ; 2*x*y + (%e^x)*sin(y)];
endfunction

// Punto inicial
x0 = [-1; 4]

// Llama a Newton multivariable
solucion = newton_multivariable(fun, x0, 0.000001, 100);
