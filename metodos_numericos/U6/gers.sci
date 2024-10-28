function circ(r,x,y)
    xarc(x-r,y+r,2*r,2*r,0,360*64)
endfunction

function gres(A)
    [n,m] = size(A);
    centros = diag(A);
    radios = sum(abs(A),'c') - abs(centros) ;
    
    // buscamos calcular un rectángulo que contenga a todos los circulos
    // esquina inferiro izquierda
    
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
