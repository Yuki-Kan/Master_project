function [ n_avg_tra_error ] = Virtual_Drift_noise(input_scenario_idx, cls_ctrs, N, gamma_noise)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% general parameters
a_mid = 30;
a_end = 100;
ls = 1/N;          % continue learning step
runs = 5;          % running times

eta = 0;              % noise strength 
eta_final = 1;
lr = 0.5;             % learning rate
lr_end = 3;


% Initial prototypes
protos = cls_ctrs;
prots_lbl = [1;2];

% initial parameters of three scenarios
p_init_linear = 0.5;  % Linear
p_max_linear = 0.8;
p_max_sudden = 0.75;  % Sudden change
p_max_osc = 0.8;      % Oscillating
T = 50;

switch input_scenario_idx
    case 1
        cls_p1 = Linear(a_mid, a_end, p_init_linear, p_max_linear, ls);
    case 2
        cls_p1 = Sudden_Change(a_mid, a_end, p_max_sudden, ls);
    case 3
        cls_p1 = Oscillation(p_max_osc, T, a_end, ls);
end

% parameters of Generation errors
lambda = 1; 
var1 = 0.4;
var2 = 0.4;

% Initial error
Q = protos * protos';
current_p1 = 0.5;
[ini_err1, ini_err2, ini_ref_err, ini_tra_err] = Gerror(protos, cls_ctrs, lambda, var1, var2, current_p1, Q); 


% parameters for generating new example under Gaussian distribution
var = 0.4;           % sigma for the normrnd spread
sigma = sqrt(var);

total_len = a_end*N;
nsum_tra_error = zeros(total_len, 1);
nsum_ref_error = zeros(total_len, 1);
nsum_err1 = zeros(total_len, 1);
nsum_err2 = zeros(total_len, 1);

% sum_tra_error = zeros(a_end-1, 1);
% sum_ref_error = zeros(a_end-1, 1);
% sum_err1 = zeros(a_end-1, 1);
% sum_err2 = zeros(a_end-1, 1);

eta_step = (eta_final-eta)/total_len;
lr_step = (lr_end-lr)/total_len;

for r = 1:runs
    fprintf('noise runs: %d\n', r);
    % start one learning phase
    tra_error_n = [];
    ref_error_n = [];
    err1_n = [];
    err2_n = [];
    i = 1;
    eta = 0;
%     lr = 0;
    
    for t = ls:ls:a_end 
        % at time step t, get p1(t) and p2(t)
%         current_p1 = cls_p1(i);
        current_p1 = 0.5;
        example_label = Class_toss(current_p1);

        % generate new example based on the label
        example_new = normrnd(cls_ctrs(example_label, :), sigma, [1, N]); 

        % LVQ1 without weight decay, gamma_noise = 0
        % lr = lr + lr_step;
        protos = LVQ1_wdecay(example_new, example_label, protos, prots_lbl, lr, N, gamma_noise);
        
        % order parameters
        Q = protos * protos';
        
        % add noise
        eta = eta + eta_step;
        proto_new = NewNoise(eta, protos, N, Q);
        protos = proto_new;

%         if ~isreal(protos)
%             break;
%         end
        
        % get generalization error
        [nerr1, nerr2, nref_err, ntra_err] = Gerror(protos, cls_ctrs, lambda, var1, var2, current_p1, Q); 
        err1_n = [err1_n; nerr1];
        err2_n = [err2_n; nerr2];
        ref_error_n = [ref_error_n; nref_err];
        tra_error_n = [tra_error_n; ntra_err];
       
        i = i+1;
    end
    
    nsum_tra_error = nsum_tra_error + tra_error_n;
    nsum_ref_error = nsum_ref_error + ref_error_n;
    nsum_err1 = nsum_err1 + err1_n;
    nsum_err2 = nsum_err2 + err2_n;
end

% average error
n_avg_tra_error = nsum_tra_error/runs;
n_avg_ref_error = nsum_ref_error/runs;
n_avg_err1 = nsum_err1/runs;
n_avg_err2 = nsum_err2/runs;



end

