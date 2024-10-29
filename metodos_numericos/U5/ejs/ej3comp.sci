clc
clear

function M = mat_it_jacobi(A)
	n = size(A,1)
	N = zeros(n,n)

	for i = 1:n
		N(i,i) = A(i,i)
	end

	M = eye(n,n) - inv(N)*A
endfunction

function x = autovalores_it(A)
	M = mat_it_jacobi(A)
	x = spec(M)
endfunction

A = [a11 a12
     a21 a22]

disp(mat_it_jacobi(A))
disp(autovalores_it(A))
