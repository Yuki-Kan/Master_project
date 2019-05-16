% run virtual drift under three scenarios respectively
clear
% general parameters
N = 200;             % dimensions
lr = 2;              % learning rate
gamma = 1;           % weight decay
eta = 0.1;           % noise strength
runs = 2;            % running times
delta = 1;           % drifting class center

% % three drift scenarios
%   idx = 1: Linear
%   idx = 2: Sudden change
%   idx = 3: Oscillation
input_scenario_idx = 1;
lschange = 50;      % change point
lstotal = 15;      % total learning steps
% p1 = DriftCase(input_scenario_idx, lschange, lstotal, N);
p1 = 0.7;

rst = ConDrift(p1, lstotal, lr, N, gamma, eta, runs, delta);
 
