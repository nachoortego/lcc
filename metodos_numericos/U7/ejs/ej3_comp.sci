clc()
clear()


function [p,err] = MinCuad_pol(A,b)
    [a,A_amp] = gausselimPP((A')*A,(A')*(b'))
    p = poly(a,"x","coeff")
    err = norm(A*a-(b'))
endfunction


function A = A_mc(x,grado)
    // p = grado+1
    m = length(x)
    A = ones(m,1)
    for j=2:(grado+1)
        A = [A,(x').^(j-1)]
    end
endfunction


function [x,a] = gausselimPP(A,b)
[nA,mA] = size(A) 
[nb,mb] = size(b)
a = [A b];
n = nA;

for k=1:n-1
    kpivot = k; amax = abs(a(k,k));
    for i=k+1:n
        if abs(a(i,k))>amax then
            kpivot = i; amax = a(i,k);
        end;
    end;
    temp = a(kpivot,:); a(kpivot,:) = a(k,:);
    a(k,:) = temp
    
    for i=k+1:n
        for j=k+1:n+1
            a(i,j) = a(i,j) - a(k,j)*a(i,k)/a(k,k)
        end;
        for j=1:k
            a(i,j) = 0;
        end
    end
end

x(n) = a(n,n+1)/a(n,n)

for i = n-1:-1:1
    sumk = 0
    for k=i+1:n
        sumk = sumk + a(i,k)*x(k)
    end
    x(i) = (a(i,n+1)-sumk)/a(i,i)
end

endfunction
x = 1:1:12
y_21 = [145.61 151.12 157.27 164.72 172.29 182.91 185.12 188.62 190.09 197.99 204.32 207.97]
y_22 = [209.92 225.82 265.71 295.24 301.62 311.80 327.39 343.10 366.54 385.20 407.77 428.42]

disp("(#) n=1.")
A = A_mc(x,1)
[p1,err1] = MinCuad_pol(A,y_21)

disp("(#) n=2.")
A = A_mc(x,2)
[p2,err2] = MinCuad_pol(A,y_21)

disp("(#) n=3.")
A = A_mc(x,3)
[p3_21,err3] = MinCuad_pol(A,y_21)
[p3_22,err3] = MinCuad_pol(A,y_22)


xx = 1:0.01:12

plot2d(xx, [horner(p3_21,xx') horner(p2,xx') horner(p1,xx')], [2, 3, 5], leg="Pan 2021")
plot2d(x,y_21, style=-1)

