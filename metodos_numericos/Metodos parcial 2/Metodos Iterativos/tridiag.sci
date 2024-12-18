function A = tridiag (N,a,b,c)
	A = b*eye(N,N) + c*diag(ones(N-1,1),1) + a*diag(ones(N-1,1),-1)
endfunction

disp(tridiag(5,1,2,3))
