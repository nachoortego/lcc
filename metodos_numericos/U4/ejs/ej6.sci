clc

function s = gauss_tridim(A)
	n = size(A,1)
	for i = 1:(n-1)
		mjk = A(i+1,i)/A(i,i)
		A(i+1,i+1:n) = A(i+1,i+1:n) - mjk*A(i,i+1:n)
		A(i+1,i)=0
	end
	s = A
endfunction

function s = gauss_tridim_2(A)
	n = size(A,1)
	for k = 1:n-1
		for j = k+1:n
			A(j, j) = A(j, j) - A(j, k) * A(k, j) / A(k, k);
			A(k+1,k) = 0 // Solo pone 0 abajo de la diagonal
		end
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
printf("\n")
disp(gauss_tridim_2(T))
