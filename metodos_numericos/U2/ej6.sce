function v = deriv(f,n,vx,h)
  if n==0 
    v=f(vx)
  else 
    v=(deriv(f,n-1,vx+h,h)-deriv(f,n-1,vx,h))/h
end
endfunction

function y = taylor(f,n,x,a)
  y = 0
  for i = (0:n)
    d_i = deriv(f,i,a,0.1)
    y = y + (d_i / (factorial(i))) * (x-a)^i
  end
endfunction

function y = exp(x)
  y = %e^x
endfunction

function y = inv_exp(x)
  y = 1/(%e^x)
endfunction

disp(taylor(exp, 10, -2, 1))
disp(taylor(inv_exp, 10, 2, 1))
