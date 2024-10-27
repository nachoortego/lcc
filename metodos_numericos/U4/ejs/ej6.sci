function s = gauss_tridim(A)
	n = size(A,1)
	for i = 1:(n-1)
		mjk = A(i+1,i)/A(i,i)
		A(i+1,i)=0
		A(i+1,i+1:n) = A(i+1,i+1:n) - mjk*A(i,i+1:n)
	end
	s = A
endfunction

T = [ 1, 4, 0, 0;
      2, 4, 1, 0;
	  0, 2, 3, 3;
	  0, 0, 3, 3; ]

disp(T)
disp("SOLUCION")
disp(gauss_tridim(T))
