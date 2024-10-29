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
    F = [x^2 + x*(y^3) - 9; 3*(x^2)*y - 4 - y^3];
endfunction

// Punto inicial
x0_a = [1.2; 2.5]
x0_b = [-2; 2.5]
x0_c = [-1.2; -2.5]
x0_d = [2; -2.5]

// Llama a Newton multivariable
solucion = newton_multivariable(fun, x0_d, 0.000001, 100);
