clc
clear

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


a = [ 1.012, -2.132, 3.104 ;
	-2.132, 4.096, -7.013 ;
	3.104, -7.013, 0.014 ; ]


b = [2.1756 4.0231 -2.1732 5.1967
-4.0231 6.0000 0 1.1973
-1.0000 5.2107 1.1111 0
6.0235 7.0000 0 4.1561]

A = b

fact_LU(A)

[L,U,P] = lu(A)

disp(U)
printf("\n")
disp(L)
printf("\n")
disp(P)


