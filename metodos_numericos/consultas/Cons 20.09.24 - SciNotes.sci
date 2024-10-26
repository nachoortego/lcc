// Método de Newton
// R^2 --> R^2
// (x1, x2) ---> (y_1, y_2) = f (x_1, x_2)

function y = f(x)
    y(1) = exp(x(1))*x(2)
    y(2) = x(1) + x(2)
endfunction

function y = f2(k)  // Ej 9
    y(1) = k(1)*exp(k(2))+k(3)-10
    y(2) = k(1)*exp(2*k(2))+2*k(3)-12
    y(3) = k(1)*exp(3*k(2))+3*k(3)-15
endfunction

function y=f3(x) // Ej 8
        y(1) = x(1)^2 + x(1)*x(2)^3 - 9
        y(2) = x(1)^2*x(2) - 4 - 3
endfunction
// 0 = x2 + xy3 − 9 ---> f1(x,y)=0
// 0 = 3x2y − 4 − y3 ---> f2(x,y)=0
// f(x,y)=(0,0)

function y = MetNewton(f,x0,iter,tol,h)
    J = numderivative(f,x0,h)
    x1 = x0 - inv(J)*f(x0) // *' = transpuesta de *
    i = 1
    
    while (norm(x1-x0)>tol) && (i < iter) // (norm(f(x1))>tol) && (i < iter)
        x0 = x1
        J = numderivative(f,x0,h)
        x1 = x0 - inv(J)*f(x0)
        i = i + 1
    end
    
    y = x1
    disp("iteraciones: ",i)
endfunction
