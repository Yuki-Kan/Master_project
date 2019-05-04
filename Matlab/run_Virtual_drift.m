% run virtual drift under three scenarios respectively

% initialize cluster centres
N = 100;
c1 = rand(1, N); 
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

% general parameters 
% idx = 1: Linear
% idx = 2: Sudden change
% idx = 3: Oscillation
input_scenario_idx = 1;

% gamma = 0;               % stength of weight decay
% gamma_final = 3;
% eta = 0;              % noise strength 
% eta_final = 1;

time_total = Virtual_Drift(input_scenario_idx, cls_ctrs, N, gamma, eta);

 
