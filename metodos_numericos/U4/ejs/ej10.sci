clc 
clear

function [L,U] = dolittle(A)
	n = size(A,1)
	U = zeros(n,n)
	L = eye(n,n)
	suma = 0
	
	U(1,:) = A(1,:)
	L(:,1) = A(:,1) / U(1,1)

	for i=2:n
		for j=1:n
			suma = L(i,1:i-1)*U(1:i-1,j)
			U(i,j) = (A(i,j) - suma)
		end
		for j=2:n
			suma = L(j,1:i-1)*U(1:i-1,i)
			L(j,i) = (A(j,i) - suma) / U(j,j)
		end
	end
	
endfunction

function [L, U] = dolittleLU(A)
	n = size(A,1)
    L = eye(n, n)
    U = A

    for k = 1:n-1
        for i = k+1:n
            L(i, k) = U(i, k) / U(k, k) // Guardar el multiplicador en L
            U(i, :) = U(i, :) - L(i, k) * U(k, :) // Modificar la fila i en U
        end
    end
endfunction

A = [ 1 2 3 4
      1 4 9 16
      1 8 27 64
      1 16 81 256 ]

[L,U] = dolittleLU(A)

disp("L")
disp(L)
disp("U")
disp(U)
