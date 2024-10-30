function [X,A_aum] = Gauss_amp(A,B)
    
   [nA, mA] = size(A);
   [nB, mB] = size(B);
   
   if nA<>mA then
        error('gausselim - La matriz A debe ser cuadrada');
        abort;
    elseif mA<>nB then
        error('gausselim - dimensiones incompatibles entre A y b');
        abort;
    end;
   
   // Matriz aumentada
   A_aum = [A,B];
   
   // Eliminación progresiva
   for i = 1:(nA-1)
		for j = (i+1):nA
			mji = A_aum(j,i)/A_aum(i,i) 
			A_aum(j,i)=0 
			A_aum(j,(i+1):(mA+1)) = A_aum(j,(i+1):(mA+1)) - mji*A_aum(i,(i+1):(mA+1))
		end
   end
       
   // Sustitución regresiva
   X(nA,1) = A_aum(nA,nA+1)./A_aum(nA,nA)
   
   for i = (nA-1):-1:1
		X(i) = (A_aum(i,mA+1) - A_aum(i,(i+1):mA)*X((i+1):mA,1))/A_aum(i,i)
   end
endfunction



function [X,A_aum] = Gauss_amp2(A,B)
    
   [nA, mA] = size(A);
   [nB, mB] = size(B);
   
   if nA<>mA then
        error('gausselim - La matriz A debe ser cuadrada');
        abort;
    elseif mA<>nB then
        error('gausselim - dimensiones incompatibles entre A y b');
        abort;
    end;
   
   // Matriz aumentada
   A_aum = [A,B];
   
   // Eliminación progresiva
	for i = 1:(nA-1) do
		for j = (i+1):nA do
			mji = A_aum(j,i)/A_aum(i,i) 
			A_aum(j,i)=0 
			A_aum(j,(i+1):(mA+mB)) = A_aum(j,(i+1):(mA+mB)) - mji*A_aum(i,(i+1):(mA+mB))
		end
	end
       
   // Sustitución regresiva
   X(nA,1:mB) = A_aum(nA,(nA+1):(nA+mB))./A_aum(nA,nA)
   
   for i = (nA-1):-1:1 do
      X(i,1:mB) = (A_aum(i,(mA+1):(mA+mB)) - A_aum(i,(i+1):mA)*X((i+1):mA,1:mB))./A_aum(i,i)
   end
endfunction



A = [1,2,3;3,-2,1;4,2,-1]
// B=[1;2;0]
B = [14,9,-2;2,-5,2;5,19,12]
[X,A_aum] = Gauss_amp2(A,B)
disp("La solución es: X=")
disp(X)
