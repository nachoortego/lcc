function[x,a]=gausselimPPTri(A,b)
    [nA,mA]=size(A)
    [nb,mb]=size(b)
    if nA<>mA then error('gausselim-La matriz A debe ser cuadrada');
                   abort;
    else 
        if mA<>nb then error('gausselim - dimensiones incompatibles entre A y b');
                       abort;
        end;
    end;
    a=[A b];//Matriz aumentada
    n=nA;//Tamaño de la matriz
    contador=0;
    //Eliminación progresiva con pivoteo parcial
    for k=1:n-1 do
        kpivot=k;
        amax=abs(a(k,k)); //pivoteo
        if abs(a(k+1,k))>amax then  temp=a(k+1,:);
                                    a(k+1,:)=a(k,:);
                                    a(k,:)=temp;//Intercambiamos las filas k y k+1
        end;
        for j=k+1:n+1 do
            a(k+1,j)=a(k+1,j)-a(k,j)*a(k+1,k)/a(k,k);
            contador=contador+3;
        end;
    end;
    //Sustitución regresiva
    x(n)=a(n,n+1)/a(n,n);
    x(n-1)=(a(n-1,n+1)-a(n-1,n)*x(n))/a(n-1,n-1);
    contador=contador+4;
    for i=n-2:-1:1 do
        x(i)=(a(i,n+1)-a(i,i+1)*x(i+1)-a(i,i+2)*x(i+2))/a(i,i);
        contador=contador+5;
    end
    disp(contador);
endfunction


function [x,a]=gausselimTri(A,b)
    [nA,mA]=size(A);
    [nb,mb]=size(b);
    if nA<>mA then error('gausselim-LamatrizAdebesercuadrada');
                   abort;
    else 
        if mA<>nb then error('gausselim - dimensiones incompatibles entre A y b');
                       abort;
        end;
    end;
    
    a=[A b];//Matriz aumentada
    n=nA;//Tamaño de la matriz
    contador=0;
    //Eliminación progresiva sin pivoteo
    for k=1:n-1 do
        mkk=a(k+1,k)/a(k,k);
        a(k+1,k+1)=a(k+1,k+1)-mkk*a(k,k+1);
        a(k+1,n+1)=a(k+1,n+1)-mkk*a(k,n+1);
        contador=contador+5;
    end;
    //Sustitución regresiva
    x(n)=a(n,n+1)/a(n,n);
    contador=contador+1;
    for k=n-1:-1:1 do
        x(k)=(a(k,n+1)-a(k,k+1)*x(k+1))/a(k,k);
        contador=contador+3;
    end;
    disp(contador);
   
endfunction
A1 = [1 1 0 0;1 1 1 0;0 1 1 1; 0 0 1 1]
b1 = [2;3;3;2]

A2 = [2 2 0 0; 5 2 2 0; 0 5 2 2; 0 0 5 2]
b2 = [6;15;24;23]

A = [2 1 0 0;1 2 1 0;0 1 2 1;0 0 1 2]
b = [1;1;1;1]
