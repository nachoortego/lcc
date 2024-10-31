function s = gauss_tridim(A)
	n = size(A,1)
	for i = 1:(n-1)
		mjk = A(i+1,i)/A(i,i)
		A(i+1,i)=0
		A(i+1,i+1) = A(i+1,i+1) - mjk*A(i,i+1)
	end
	s = A
endfunction

N = 5
T = 8*eye(N,N) + 2*diag(ones(N-1,1),1) + 2*diag(ones(N-1,1),-1)
b = ones(N,1)


disp(T)
disp("SOLUCION")
disp(gauss_tridim(T))
