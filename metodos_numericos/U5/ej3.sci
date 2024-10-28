//ej3
n = 4
A = 2*eye(n,n) + -1*diag(ones(n-1,1),1) + -1*diag(ones(n-1,1),-1)
N = 2*eye(n,n) + -1*diag(ones(n-1,1),-1)
N = inv(N)

disp(N)
disp(eye(n,n) - N*A)
