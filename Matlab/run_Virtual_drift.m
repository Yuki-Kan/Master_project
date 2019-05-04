% run virtual drift under three scenarios respectively
clear
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


% % three drift scenarios
%   idx = 1: Linear
%   idx = 2: Sudden change
%   idx = 3: Oscillation
input_scenario_idx = 1;
a_mid = 30;    
a_end = 100;   % total learning steps
% cls_p1 = DriftCase( input_scenario_idx, a_mid, a_end, N);
cls_p1 = 0.5;

runs = 1;                  % running times

a = VirtualDrift(cls_p1, a_end, cls_ctrs, N, runs);
% b = VirtualDrift_wd(cls_p1, a_end, cls_ctrs, N, runs);
% c = VirtualDrift_noise(cls_p1, a_end, cls_ctrs, N, runs);
 
