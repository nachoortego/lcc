function v = deriv(f,n,vx,h)
if n==0 then v=f(vx)
else v=(deriv(f,n-1,vx+h,h)-deriv(f,n-1,vx,h))/h
end
endfunction

function y = taylor( f , n , x, a)
y = 0
for i = (0:n)
d_i = deriv(f,i,a,0.1)
y = y + (d_i / (factorial(i))) * (x-a)^i
end
endfunction

function y = sqr(x)
y = x^2
endfunction

disp(taylor(sqr, 10, 2, 4))