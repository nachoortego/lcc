function [x,cont] = SOR(A,b,x0,eps,w)
    x = x0;
    [n,m] = size(A);
    cont = 0;
    while cont==0 || norm(x-x0)>eps
        x0 = x;
        for i = 1:n
            if(i == 1) then
                suma = 0
                for j=2:n
                    suma = suma + A(1,j)*x0(j);
                end
                x(1) = (1-w)*x0(1) + (w/A(i,i))*(b(1)-suma);
            else if(i<>n) then
                suma1 = 0;
                for j=1:i-1
                    suma1 = suma1 + A(i,j)*x(j);
                end
                suma2 = 0;
                for j=i+1:n
                    suma2 = suma2+ A(i,j)*x0(j);
                end
                x(i) = (1-w)*x0(i)+(w/A(i,i))*(b(i)-suma1-suma2);
            else
                suma = 0;
                for j=1:n-1
                    suma = suma+ A(n,j)*x(j);
                end
                x(n) = (1-w)*x0(n)+(w/A(n,n))*(b(n)-suma);
            end
            end
        end // Obtuve iteracion en x
        cont = cont + 1;
    end
    disp(cont);
endfunction

function w = omega_opt(A)
    // A es definida positiva y tridiagonal
    n = size(A)(1);
    T_j = eye(n,n)-diag(1./diag(A))*A;
    autovalores = spec(T_j);
    rho = max(abs(autovalores));
    w=2/(1+sqrt(1-rho**2));
endfunction	

A = [4,3,0;3,4,-1;0,-1,4]
b = [24;30;-24]
x0 = [1;4;3] // Condición inicial
tol = 10^(-7)
iter = 500

w = 1
[x,iter] = SOR(A,b,x0,tol,w)
disp("a) El método de Gauss-Seidel.")
disp("El omega utilizado es: 1")
disp("La cantidad de iteraciones es: "+string(iter))
disp("La solución con tolerancia 10^(-7) es: ")
disp(x)

w = omega_opt(A)
[x,iter] = SOR(A,b,x0,tol,w)
disp("b) El método de SOR con el parámetro de relajación óptimo.")
disp("El omega óptimo es: "+string(w))
disp("La cantidad de iteraciones es: "+string(iter))
disp("La solución con tolerancia 10^(-7) es: ")
disp(x)
