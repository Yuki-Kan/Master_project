% run virtual drift under three scenarios respectively
clear
% general parameters
N = 200;             % dimensions
lr = 1;              % learning rate
gamma = 1;           % gamma
eta = 0.02;          % eta
runs = 1;            % running times


% % three drift scenarios
%   idx = 1: Linear
%   idx = 2: Sudden change
%   idx = 3: Oscillation
input_scenario_idx = 1;
lschange = 50;      % change point
lstotal = 200;      % total learning steps
p1 = DriftCase(input_scenario_idx, lschange, lstotal, N);
% cls_p1 = 0.5;

rst = VirtualDrift(p1, lstotal, lr, N, gamma, eta, runs);
 
