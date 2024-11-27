// Raíces del polinomio de Chebyshev
function w = roots_Cheby(n)
    // Entrada: n = grad del polinomio de Chebyshev
    // Salida: w = vector con las raices del polinomio de Chebyshev
    for i=0:(n-1) do
        w(i+1)=cos((2*i+1)*%pi/(2*n))
    end
endfunction

// Raíces del polinomio de Chebyshev
function w = roots_Cheby_ab(n,a,b)
    for i=0:(n-1) do
        w(i+1)=cos((2*i+1)*%pi/(2*n))
    end
    w = ((b-a)*w + (b+a))/2
endfunction

// Polinomio de Chebyshev
function w = Cheby(x,n)
    // Entrada: n = número natural; x = número real
    // Salida: Polinomio de Chebyshev de grado n evaluado en x
    if n==0 then
        w = 1
    elseif n==1 then
        w = x
    elseif n==2 then
        w = 2*x.^2-1
    else
        w = 2*x.*Cheby(x,n-1)-Cheby(x,n-2)
    end
endfunction

// Nodos equiespaciados para comparar
function w = nodos_equidist(n,a,b)
    w = a:(b-a)/n:b // Nodos equiespaciados
endfunction
