function raiz = falsa_posicion(fun, a, b, tol, iter)
	deff("y=f(x)","y="+fun)

    if f(a) * f(b) >= 0 then
        disp("Error: f(a) y f(b) deben tener signos opuestos.");
        return;
    end

    // Variables iniciales
    i = 0;
    while i < iter do
        c = b - (f(b) * (b - a)) / (f(b) - f(a));
        
        f_c = f(c);
        
        if abs(f_c) < tol then
            root = c;
            return;
        end
        
        if f(a) * f_c < 0 then
            b = c;
        else
            a = c;
        end
        i = i + 1;
    end

	disp(i)
	disp(c)
	raiz = c
endfunction

falsa_posicion("x^3 - x - 2",1,2,0.001,100)
