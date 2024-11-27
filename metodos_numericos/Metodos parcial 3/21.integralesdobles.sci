// Material de clase, no son implementaciones óptimas para usar en
// TPs o examenes

funcprot(0); // apaga los Warning por redefinir funciones
clc
clear
function v=TnExt(f,a,b,c,d)
    h = (b-a)*(d-c)/4
    v = h*(f(c,a)+f(c,b)+f(d,a)+f(d,b))
endfunction

function v = Tn(fx,a,b,n)
    h = (b-a)/n;
    v = (fx(a)/2)+ (fx(b)/2);
    for i = 1 : n-1
        xi = a+i*h;
        v = v + fx(xi);
    end
    v = h*v;
endfunction

// el hecho de resolver este ejercicio definiendo nuevas funciones No
// es lo esperado y solo se hace así por motivos didácticos.
function v=DobleTn(f,a,b,c,d,n,m)
    h = (b-a)/n
    deff("z=fxa(y)","z=f("+string(a)+",y)")
    deff("z=fxb(y)","z=f("+string(b)+",y)")
    v = Tn(fxa,c(a),d(a),m)/2+Tn(fxb,c(b),d(b),m)/2
    for i=1:n-1
        xi = a+i*h
        deff("z=fxi(y)","z=f("+string(xi)+",y)")
        v = v + Tn(fxi,c(xi),d(xi),m)
    end
    v = h*v
endfunction

function y=zero(x)
         y= 0
endfunction

function z=uno(x,y)
         z= 1
endfunction

function w = f(x,y) 
	w = sin(x+y)
endfunction

disp(DobleTn(f,0,2,zero,uno,5,5))
