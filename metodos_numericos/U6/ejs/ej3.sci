clc

ε = 0.4
A = [ 1 -1 0
     -2 4 -2
     0 -1 1+ε]

n = size(A)
disp(A)
disp(poly(A, 'x'))
//disp(x*eye(n)-A)
disp("Autovalor " + string(spec(A)))
    roots_P = roots(poly(A, 'x'))
    disp("Raíces aproximadas:")
    disp(roots_P);
