function [U,L,P] = fact_LU(A)
	n = size(A,1)
	U = A
	L = eye(n,n)
	P = eye(n,n)

	for k=1:n-1
		c = abs(U(k,k))
		kpivoteo = k
		for i=k+1:n
			if abs(U(i,k)) > c
				kpivoteo = i
				c = abs(U(i,k))
			end
		end
		if kpivoteo <> k
			auxswap = U(k,k:n)
			U(k,k:n) = U(kpivoteo,k:n)
			U(kpivoteo,k:n) = auxswap // cambio de filas en U
	
			auxswap = L(k,1:k-1)
			L(k,1:k-1) = L(kpivoteo,1:k-1)
			L(kpivoteo,1:k-1) = auxswap // cambio de filas en L
	
			auxswap = P(k,:)
			P(k,:) = P(kpivoteo,:)
			P(kpivoteo,:) = auxswap // cambio de filas en P
		end

		L(k+1:n,k) = U(k+1:n,k) / U(k,k)
		U(k+1:n,k:n) = U(k+1:n,k:n) - L(k+1:n,k)*U(k,k:n)
	end

	disp(A)
	printf("\n")
	disp(U)
	printf("\n")
	disp(L)
	printf("\n")
	disp(P)
	printf("\n")
	printf("\n")

endfunction

A = [	2 1 1 0
		4 3 3 1
		8 7 9 5
		6 7 9 8 ]

[U,L,P] = fact_LU(A)
disp(P*A)
printf("\n")
disp(L*U)
