// a)
A = [ 2 -1 
      -1 2 ]

//Como la matriz es diagonal dominante, converge para ambos metodos con cualquier vector inicial.

// b) 

function M = mat_it_gauss_seidel(A)
	disp("gauss seidel")
	n = size(A,1)
	N = zeros(n,n)

	for i = 1:n
		N(i,1:i) = A(i,1:i)
	end

	M = eye(n,n) - inv(N)*A
endfunction

function M = mat_it_jacobi(A)
	disp("jacobi")
	n = size(A,1)
	N = zeros(n,n)

	for i = 1:n
		N(i,i) = A(i,i)
	end

	M = eye(n,n) - inv(N)*A
endfunction

B = [ -1 2
      2 -1 ]

s1 = max(abs(spec(mat_it_gauss_seidel(B))))
disp(s1)
s2 = max(abs(spec(mat_it_jacobi(B))))
disp(s2)

// No convergen!!!!!

// c)
function y = r1(x)
	y = 2*x-1
endfunction

function y = r2(x)
	y = (x+1)/2
endfunction

xx = 0:0.1:10
plot2d(xx,r1(xx),2)
plot2d(xx,r2(xx),5)
plot2d(1,1,style=-1)


function x = jacobi(A,b,x0,eps,max_iter)
    n = size(A,1)
    x = x0
    xk = x
    cont = 0

    while (norm(x-xk) > eps || cont == 0) && cont < max_iter
        xk = x
        for i = 1:n
            suma = 0
            for j = 1:n
                if (i <> j)
                    suma = suma + A(i,j)*xk(j)
                end
            end
            x(i) = 1/A(i,i)*(b(i) - suma)
        end
        cont = cont + 1
    end
    disp(cont);
endfunction

function x = gauss(A,b,x0,eps,max_iter)
    n = size(A,1)
    x = x0
    xk = x
    cont = 0

    while (norm(x-xk) > eps || cont == 0) && cont < max_iter
        xk = x
        for i = 1:n
            suma = 0
            for j = 1:n
                if (i <> j)
                    suma = suma + A(i,j)*x(j)
                end
            end
            x(i) = 1/A(i,i)*(b(i) - suma)
        end
        cont = cont + 1
    end
    disp(cont);
endfunction

x0 = [3,4.5] 

j = (jacobi(A,[1,1],x0,0.001,2))
g = (gauss(A,[1,1],x0,0.001,2))


plot2d(j(1),j(2),style=-1)
plot2d(g(1),g(2),style=-1)



