function [L,U]=crout(A)
    n=size(A,1)
    U=eye(n,n)
    L=zeros(n,n)

    for j = 1:n
        for i = 1:n
            suma = 0
            for k = 1:j-1
                suma = suma + (L(i,k)*U(k,j))
            end
            if i >= j then
                L(i,j) = A(i,j) - suma
            elseif i <= j then
                U(i,j) = (1/L(i,i))*(A(i,j)-suma)
            end
        end
    end
endfunction
