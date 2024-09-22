// NOTAS DE CLASE

// funcion f es la ley de la función dada por un string, usa como 
// variable x
// v es el valor donde se evaluará la derivada
// n es el orden de derivación
// h es el paso de derivación

function valor = derivada(f,v,n,h)
    deff("y=DF0(x)","y="+f);
    if n==0 then valor = DF0(v);
    else
        for i=1:(n-1)
        deff("y=DF"+string(i)+"(x)","y=(DF"+string(i-1)+"(x+"+string(h)+")-DF"+string(i-1)+"(x))/"+string(h));
        end
        deff("y=DFn(x)","y=(DF"+string(n-1)+"(x+"+string(h)+")-DF"+string(n-1)+"(x))/"+string(h));
        valor = DFn(v);
    end
endfunction

// usando numderivative
// esta función utiliza un orden para numderivative igual a 4
function valor = derivadaNum(f,v,n,h)
    deff("y=DF0(x)","y="+f);
    if n==0 then valor = DF0(v);
    else
        for i=1:(n-1)
            deff("y=DF"+string(i)+"(x)","y=numderivative(DF"+string(i-1)+",x,"+string(h)+",4)");
        end
        deff("y=DFn(x)","y=numderivative(DF"+string(n-1)+",x,"+string(h)+",4)");
        valor = DFn(v);
    end
endfunction

// EJERCICIO

function v = deriv(f,vx,n,h)
    if n == 0
        v = f(vx);
    else
        v = (deriv(f,vx+h,n-1,h) - deriv(f,vx,n-1,h))/h;
    end
endfunction

function y = f(x)
    y = x^3;  // Definir f(x) = x^3
endfunction

v = 2;  // Punto donde calcular la derivada
n = 1;  // Primera derivada
h = 0.01;  // Paso de diferencia

y = deriv(f,v,n,h);
disp("Primera derivada de f(x) = x^3 en x = 2: " + string(y));
