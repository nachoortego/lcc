function [s1, s2] = gauss(A, b)
	a = size(A)
	n = a(1)
	for k = 1:(n-1)
		mjk = A(k+1:n,k)/A(k,k)
		A(k+1:n,k)=0
		A(k+1:n,k+1:n) = A(k+1:n,k+1:n) - mjk*A(k,k+1:n)
		b(k+1:n) = b(k+1:n) - mjk*b(k)
	end
	s1 = A
	s2 = b
endfunction

function d = det_gauss(A)
	n = size(A,1)
	b = zeros(n,1)
	[s1, s2] = gauss(A,b)
	disp(s1)
	d = prod(diag(s1))
endfunction

A = [ 1 2 3;
      1 7 3;
      4 5 0; ]

disp(det_gauss(A))
