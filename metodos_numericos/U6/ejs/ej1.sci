function circ(r,x,y)
    xarc(x-r,y+r,2*r,2*r,0,360*64)
endfunction

function gres(A)
    [n,m] = size(A);
    centros = diag(A);
    radios = sum(abs(A),'c') - abs(centros) ;
    
    // buscamos calcular un rectángulo que contenga a todos los circulos
    // esquina inferior izquierda
    
    mx = round (min(centros - radios)-1);
    my = round (min(-radios)-1);
    
    // esquina superior derecha
    
    Mx = round(max(centros+radios)+1);
    My = round(max(radios)+1);
    
    rectangulo = [mx my Mx My];
    
    // dibujamos los autovalores
    plot2d(real(spec(A)),imag(spec(A)),-1,"031","",rectangulo)
    replot(rectangulo); // reeplaza al rect
    xgrid();
    
    for i=1:n
        circ(radios(i),centros(i),0)
    end
    
endfunction


A = [ 1 0 0
     -1 0 1
     -1 -1 2 ]

B = [ 1 0 0
     -0.1 0 0.1
     -0.1 -0.1 2 ]

E = [ 3 2 1
      2 3 0
      1 0 3 ]

F = [
      4.75 2.25 -0.25
      2.25 4.75 1.25
      -0.25 1.25 4.75 ]

//gres(A')
//gres(A)

disp(spec(E))
