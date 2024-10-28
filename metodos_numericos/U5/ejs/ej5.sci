// Ejercicio 5 de la Práctica 5
clc()
clear()

// SOR
function [x0,iter] = SOR(w,tol)
    // Entrada: W parámetro del método de SOR; tol = tolerancia
    // Salida: x = paroximación de Ax = b por el método de SOR
    
    A = [4,3,0;3,4,-1;0,-1,4]
    b = [24;30;-24]
    x0 = [1;0;0] // Condición inicial
    n = 3
    err = tol + 1
    iter = 0
    
    while err > tol // Método de SOR
        x0(1) = (1-w)*x0(1) + (w/A(1,1))*(b(1) - A(1,2:n)*x0(2:n))
        for i=2:n-1
            x0(i) = (1-w)*x0(i) + (w/A(i,i))*(b(i) - A(i,1:i-1)*x0(1:i-1) - A(i,i+1:n)*x0(i+1:n))
        end
        x0(n) = (1-w)*x0(n) + (w/A(n,n))*(b(n) - A(n,1:n-1)*x0(1:n-1))
        err = norm([3;4;-5]-x0,2)
        iter = iter + 1
    end
    
endfunction

// Omega óptimo
function w = omega_SOR(A)
    // Entrada: A matriz nxn tridiagonal y definida positiva
    // Salida: w óptimo del método de SOR
    
    [n,m] = size(A)
    T_j = eye(n,n)-diag(1./diag(A))*A
    autovalores = spec(T_j)
    rho = max(abs(autovalores))
    w = 2/(1+sqrt(1-rho^2))
    
endfunction

// - %%%%%%%%%%%%%%%%%%%%%%%%% - //

// ítem a
tol = 10^(-7)
w = 1
[x,iter] = SOR(w,tol)
disp("a) El método de Gauss-Seidel.")
disp("El omega utilizado es: 1")
disp("La cantidad de iteraciones es: "+string(iter))
disp("La solución con tolerancia 10^(-7) es: ")
disp(x)

// ítem b
tol = 10^(-7)
A = [4,3,0;3,4,-1;0,-1,4]
w = omega_SOR(A)
[x,iter] = SOR(w,tol)
disp("b) El método de SOR con el parámetro de relajación óptimo.")
disp("El omega óptimo es: "+string(w))
disp("La cantidad de iteraciones es: "+string(iter))
disp("La solución con tolerancia 10^(-7) es: ")
disp(x)
