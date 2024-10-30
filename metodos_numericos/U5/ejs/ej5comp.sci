clc
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

A = [
10 -1 2 0
-1 11 -1 3
2 -1 10 -1
0 3 -1 8]

b = [ 6 25 -11 15]


G = (mat_it_gauss_seidel(A))
J = (mat_it_jacobi(A))

disp(spec(G))
disp("_______________________")
disp(spec(J))
