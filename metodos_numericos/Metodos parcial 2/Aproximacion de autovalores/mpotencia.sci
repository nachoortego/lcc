clc
clear

function [valor,zn,iter]=mpotencia(A,z0,eps,maxiter)
    valor = 0;
    iter = 1;
	zn = z0

    while ((iter <= maxiter) & (norm(z0-zn,%inf)>eps)) || iter == 1
        if (iter <> 1)
			z0 = zn;
		end
        w = A*z0;
        zn = w / norm(w,%inf)
        [m,j] = max(abs(w));
        valor = w(j) / z0(j);
        zn = w/valor;

        iter = iter +1;
    end

    disp("Iteraciones",iter);
endfunction
