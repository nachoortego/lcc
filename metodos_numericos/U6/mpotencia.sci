function [valor,zn]=mpotencia(A,z0,eps,maxiter)
    valor = 0;
    iter = 1;
    w = A*z0;
    zn = w / norm(w,%inf)
    [m,j] = max(abs(w));
    valor = w(j) / z0(j);
    zn = w/valor;
    while (iter <= maxiter) & (norm(z0-zn,%inf)>eps)
        z0 = zn;
        w = A*z0;
        zn = w / norm(w,%inf)
        [m,j] = max(abs(w));
        valor = w(j) / z0(j);
        zn = w/valor;
        iter = iter +1;
    end
    disp("Iteraciones",iter);    
endfunction

A = [12 1 3 4;1 -3 1 5;3 1 6 -2; 4 5 -2 -1]

