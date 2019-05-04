function [ wdavg_tra_error ] = Virtual_Drift( input_scenario_idx, cls_ctrs, N)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% general parameters
a_mid = 30;
a_end = 100;
lr = 0.5;          % learning rate
lr_end = 3;
ls = 1/N;          % continue learning step
runs = 5;         % running times
tic;

gamma = 0;               % stength of weight decay
gamma_final = 1;

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
wdsum_tra_error = zeros(total_len, 1);
wdsum_ref_error = zeros(total_len, 1);
wdsum_err1 = zeros(total_len, 1);
wdsum_err2 = zeros(total_len, 1);

% sum_tra_error = zeros(a_end-1, 1);
% sum_ref_error = zeros(a_end-1, 1);
% sum_err1 = zeros(a_end-1, 1);
% sum_err2 = zeros(a_end-1, 1);

gamma_step = (gamma_final-gamma)/total_len;
lr_step = (lr_end-lr)/total_len;


% ===========================================
% experiments with weight decay
for r = 1:runs
    fprintf('runs: %d\n', r);
    % start one learning phase
    tra_error_wd = [];
    ref_error_wd = [];
    err1_wd = [];
    err2_wd = [];
    i = 1;
    gamma = 0;
%     lr = 0;
    
    for t = ls:ls:a_end 
        % at time step t, get p1(t) and p2(t)
%         current_p1 = cls_p1(i);
        current_p1 = 0.5;
        example_label = Class_toss(current_p1);

        % generate new example based on the label
        example_new = normrnd(cls_ctrs(example_label, :), sigma, [1, N]); 

        % LVQ1 with weight decay
        gamma = gamma + gamma_step;
        % lr = lr + lr_step;
        protos = LVQ1_wdecay(example_new, example_label, protos, prots_lbl, lr, N, gamma);
        
        % order parameters
        Q = protos * protos';
        
        % get generalization error
        [wderr1, wderr2, wdref_err, wdtra_err] = Gerror(protos, cls_ctrs, lambda, var1, var2, current_p1, Q); 
        err1_wd = [err1_wd; wderr1];
        err2_wd = [err2_wd; wderr2];
        ref_error_wd = [ref_error_wd; wdref_err];
        tra_error_wd = [tra_error_wd; wdtra_err];
        
%         if rem(i,N)==0
%             err1_array = [err1_array; err1];
%             err2_array = [err2_array; err2];
%             ref_error_array = [ref_error_array; ref_err];
%             tra_error_array = [tra_error_array; tra_err];
%         end
        i = i+1;
    end
    
    wdsum_tra_error = wdsum_tra_error + tra_error_wd;
    wdsum_ref_error = wdsum_ref_error + ref_error_wd;
    wdsum_err1 = wdsum_err1 + err1_wd;
    wdsum_err2 = wdsum_err2 + err2_wd;
end

% average error
wdavg_tra_error = wdsum_tra_error/runs;
wdavg_ref_error = wdsum_ref_error/runs;
wdavg_err1 = wdsum_err1/runs;
wdavg_err2 = wdsum_err2/runs;


end

