function [s1, s2] = gauss(A, b)
	a = size(A)
	n = a(1)
	for i = 1:(n-1)
		for j = (i+1):a(1)
			mjk = A(j,i)/A(i,i)
			A(j,i)=0
			A(j,i+1:n) = A(j,i+1:n) - mjk*A(i,i+1:n)
			b(j) = b(j) - mjk*b(i)
		end
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
