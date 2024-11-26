function [p,err] = MinCuad_pol(A,b)
    [a,A_amp] = gausselimPP((A')*A,(A')*(b'))
    p = poly(a,"x","coeff")
    err = norm(A*a-(b'))
endfunction

function A = A_mc(x)
    m = length(x)
    A = ones(m,1)
    for j=1:3
        A = [A,(x').^(j+1)]
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

x = [-2.0 -1.6 -1.2 -0.8 -0.4 0 0.4 0.8 1.2 1.6 2.0]
y = [1.50 0.99 0.61 0.27 0.02 -0.0096 0.065 0.38 0.63 0.98 1.50]

A = A_mc(x)
[p err] = MinCuad_pol(A,y)
disp(p)


xx = -2:0.01:2

plot2d(xx, [ horner(p,xx) ], [2],leg="p4(x)@xx")
plot2d(x, y, style=-1, leg="Datos");

a = gca()
a.x_location = "origin"
a.y_location = "origin"
