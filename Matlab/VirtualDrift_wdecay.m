function [wderr1, wderr2, wdtra_err, wdref_err] = VirtualDrift_wdecay(cls_p1, a_end, cls_ctrs, N, runs, gamma_final, lr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% general parameters
ls = 1/N;                % continue learning step

% Initial prototypes with unit length
protos = Iniprotos(N); 
% protos = cls_ctrs;
prots_lbl = [1;2];

% parameters used for Generation errors
lambda = 1; 
var1 = 0.4;
var2 = 0.4;

% Initial error, no training yet
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

% used when increasing gamma
gamma = 0;
gamma_step = (gamma_final-gamma)/total_len;


% =============================================
% experiments with weight decay
for k = 1:runs
    fprintf('wd runs: %d\n', k);
    
    tra_error_wd = [];
    ref_error_wd = [];
    err1_wd = [];
    err2_wd = [];
    
    Qs12 = [];
    Qs21 = [];
    Rs12 = [];
    Rs21 = [];
    
    i = 1;
    % gamma = 0;
    
    for t = ls:ls:a_end 
        % at time step t, get p1(t) and p2(t)
        % current_p1 = cls_p1(i);
        current_p1 = cls_p1;
        example_label = Class_toss(current_p1);

        % generate new example based on the label
        example_new = normrnd(cls_ctrs(example_label, :), sigma, [1, N]); 

        % LVQ1 with weight decay
        % gamma = gamma + gamma_step;
        gamma = gamma_final;
        [protos, Q, R] = LVQ1_wdecay(example_new, example_label, protos, prots_lbl, lr, N, gamma);
        
        % add this in order to plot Q and R, only for one run
        Q12 = Q(1,2);
        Q21 = Q(2,1);
        Qs12 = [Qs12; Q12];
        Qs21 = [Qs21; Q21];
        
        R12 = R(1,2);
        R21 = R(2,1);
        Rs12 = [Rs12; R12];
        Rs21 = [Rs21; R21];
       
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

wderr1 = cat(1, ini_err1, wdavg_err1);
wderr2 = cat(1, ini_err2, wdavg_err2);
wdtra_err = cat(1, ini_tra_err, wdavg_tra_error);
wdref_err = cat(1, ini_ref_err, wdavg_ref_error);


figure;
hold on
plot(1:length(Rs12), Rs12)
plot(1:length(Rs21), Rs21)
plot(1:length(Qs12), Qs12)
plot(1:length(Qs21), Qs21)
hold off
legend({'Rs21','Rs12', 'Qs12', 'Qs21'}, 'location', 'northeast')
xlabel('learning time')
ylabel('R and Q')
title(['Q and R (wd, N = ' num2str(N) ', gamma = ' num2str(gamma_final) ' )'])


end

