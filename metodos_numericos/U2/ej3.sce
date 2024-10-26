function b = horner(p, x)
  n = degree(p)  
  b = 0;
  for i = [n: -1: 0]
    b = coeff(p,i) + x * b;
  end

endfunction


function b = horner_gen(p, x)
    n = degree(p);
    b(1) = 0
    b(2) = 0
    for i = [n: -1: 0]
      b(1) = coeff(p,i) + x * b(1);
      if (i >= 1) then 
        b(2) = b(1) + x * b(2);
      end
    end

endfunction

p = poly([2 3 -5],"x","coeff");

disp(better_horner(p, 2))