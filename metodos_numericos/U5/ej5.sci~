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

A = [12 1 3 4
1 -3 1 5
3 1 6 -2
 4 5 -2 -1]

B = [6 4 4 1
4 6 1 4
4 1 6 4
1 4 4 6]

C = [
12 1 3 4
1 -3 1 5
3 1 6 -2
4 5 -2 -1]

//[valor,zn]=mpotencia(C,[2 0 4 1]',0.0001,500)
//
//disp("Valor: " + string(valor))
//disp("Zn: " + string(zn))

function comparar_autovalores(A, z0, eps, maxiter)
    // Llamamos al metod de la potencia
    [valor_aprox, zn, iter] = mpotencia(A, z0, eps, maxiter);

    // Calculamos los autovalores exactos usando spec()
    autovalores = spec(A);
    autovalor_max = max(autovalores);  // Mayor autovalor exacto

    // Calculamos la diferencia entre el mayor autovalor y el valor aproximado
    diferencia = abs(autovalor_max - valor_aprox);

    // Mostramos los resultados
    disp("Autovalor aproximado: " + string(valor_aprox));
    disp("Mayor autovalor exacto: " + string(autovalor_max));
    disp("Diferencia: " + string(diferencia));
    disp("Iteraciones realizadas: " + string(iter));
endfunction

comparar_autovalores(C, [2 0 4 1]', 0.0001, 500)
