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

A = [1 -1  0  ;
     -1 2 -1 ;
     0 -1 1.1 ;]

M = mat_it_jacobi(A)

disp(M)
disp(norm(M))

if norm(M) < 1
	disp("converge")
else
	disp("no converge")
end
