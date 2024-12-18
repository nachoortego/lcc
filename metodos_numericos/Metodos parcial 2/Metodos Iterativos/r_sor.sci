function s = r_sor(w, A)
	n = size(A,1)
	D = diag(diag(A))
	U = diag(diag(A,1),1)
	L = diag(diag(A,-1),-1)
	T = inv(D+w*L)*((1-w)*D-w*U)
	s = max(abs(spec(T)))
endfunction

A = [ 10 5 0 0
      5 10 -4 0
      0 -4 8 -1
      0 0 -1 5 ]

b = [6 25 -11 -11]

xx = 1:01:10
for i = 1:0.1:10
	yy(i*9) =  r_sor(i,A)
end


plot(xx,yy)
