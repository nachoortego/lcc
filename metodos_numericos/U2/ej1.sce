function r = misraices(p)
  c = coeff(p,0);
  b = coeff(p,1);
  a = coeff(p,2);
  r(1) = (-b + sqrt(b^2-4*a*c))/(2*a);
  r(2) = (-b - sqrt(b^2-4*a*c))/(2*a);
  endfunction

p = poly([-0.0001 10000.0 0.0001],"x","coeff");
e1 = 1e-8;
roots1 = misraices(p);
r1 = roots1(1);
roots2 = roots(p);
r2 = roots2(2);
error1 = abs(r1-e1)/e1;
error2 = abs(r2-e1)/e1;
printf("Esperado : %e\n", e1);
printf("misraices (nuestro) : %e (error= %e)\n", r1, error1);
printf("roots (Scilab) : %e (error= %e)\n", r2, error2);


// EJERCICIO RESUELTO
printf("EJERCICIO RESUELTO\n");

function r = misraices_robustas(p)
  c = coeff(p, 0);
  b = coeff(p, 1);
  a = coeff(p, 2);
  delta = b^2 - 4*a*c;
  
  if delta < 0 then
      error("El discriminante es negativo, no hay raíces reales.");
  end
  
  if b > 0 then
      // Calcula x- con la fórmula tradicional y x+ con la fórmula alternativa
      r(1) = (-b - sqrt(delta)) / (2*a);
      r(2) = (2*c) / (-b - sqrt(delta));
  else
      // Calcula x- con la fórmula alternativa y x+ con la fórmula tradicional
      r(1) = (2*c) / (-b + sqrt(delta));
      r(2) = (-b + sqrt(delta)) / (2*a);
  end
endfunction

// Parámetros
epsilon = 0.0001;
p = poly([-epsilon, 1/epsilon, epsilon], "x", "coeff");
e1 = epsilon^2;  // Raíz esperada (positiva)

// Cálculo de las raíces
roots_robust = misraices_robustas(p);
r_robust = roots_robust(2);  // Raíz positiva

// Cálculo con la función roots de Scilab
roots_scilab = roots(p);
r_scilab = roots_scilab(2);

// Error relativo
error_robust = abs(r_robust - e1) / e1;
error_scilab = abs(r_scilab - e1) / e1;

// Imprime resultados
printf("Raíz esperada: %e\n", e1);
printf("misraices_robustas: %e (error relativo = %e)\n", r_robust, error_robust);
printf("roots (Scilab): %e (error relativo = %e)\n", r_scilab, error_scilab);
