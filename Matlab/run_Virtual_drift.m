% run virtual drift under three scenarios respectively
% initialize cluster centres
N = 100;
c1 = randn(1, N); 
c1 = c1/norm(c1);
% null-space orthogonal to w1
nu1 = null(c1); 
dim1 = N-1;
% random coefficients
rc1 = rand(dim1,1); 
% construct new vector with random coefficients
c2 = (nu1*rc1)';
c2 = c2/norm(c2);
cls_ctrs = [c1; c2];

% linear
time_total = Virtual_Drift(1, cls_ctrs, N);

% sudden change
Virtual_Drift(2)

% oscilation
Virtual_Drift(3)
 
