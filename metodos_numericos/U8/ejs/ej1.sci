function integral = reglaSimpson(fun, a, b)
    deff("y=f(x)","y=" + fun); // Define la funcion
    h = (b - a)/2
    integral = (h/3) * (f(a) + 4*f(a+h) + f(b))
endfunction

function integral = metodoTrapecio(fun, a, b)
    deff("y=f(x)","y=" + fun) // Define la funcion
    h = b - a
    integral = (h/2) * (f(a) + f(b))
endfunction

//a
disp("EJERCICIO a)")
disp(reglaSimpson("log(x)",1,2))
disp(metodoTrapecio("log(x)",1,2))

ln_2_deriv = "-1/x^2"

//b
disp("EJERCICIO b)")
disp(reglaSimpson("x^(1/3)",0,0.1))
disp(metodoTrapecio("x^(1/3)",0,0.1))

//c
disp("EJERCICIO c)")
disp(reglaSimpson("(sin(x))^2",0,%pi/3))
disp(metodoTrapecio("(sin(x))^2",0,%pi/3))
