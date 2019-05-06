function [wderr1, wderr2, wdtra_err, wdref_err] = VirtualDrift_wdecay(cls_ctrs, iniprotos, p1, a_end, N, runs, gamma_final, lr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% general parameters
ls = 1/N;                % continue learning step
protos = iniprotos;
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

% sum_Qs11 = zeros(total_len, 1);
% sum_Qs22 = zeros(total_len, 1);
% sum_Qs12 = zeros(total_len, 1);
% sum_Qs21 = zeros(total_len, 1);
sum_Rs11 = zeros(total_len, 1);
sum_Rs22 = zeros(total_len, 1);

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
    
%     Qs11 = [];
%     Qs22 = [];
    Rs11 = [];
    Rs22 = [];
    
    i = 1;
    % gamma = 0;
    
    for t = ls:ls:a_end 
        % at time step t, get p1(t) and p2(t)
        % current_p1 = cls_p1;
        current_p1 = p1(i);
        example_label = Class_toss(current_p1);

        % generate new example based on the label
        example_new = normrnd(cls_ctrs(example_label, :), sigma, [1, N]); 

        % LVQ1 with weight decay
        % gamma = gamma + gamma_step;
        gamma = gamma_final;
        [protos, Q] = LVQ1_wdecay(example_new, example_label, protos, prots_lbl, lr, N, gamma);
        
        % add this in order to plot Q and R, only for one run
%         Q11 = Q(1,1);
%         Q22 = Q(2,2);
%         Qs11 = [Qs11; Q11];
%         Qs22 = [Qs22; Q22];
        
        R = iniprotos * protos';
        R11 = R(1,1);
        R22 = R(2,2);
        Rs11 = [Rs11; R11];
        Rs22 = [Rs22; R22];
       
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
    
%     sum_Qs11 = sum_Qs11 + Qs11;
%     sum_Qs22 = sum_Qs22 + Qs22;
    sum_Rs11 = sum_Rs11 + Rs11;
    sum_Rs22 = sum_Rs22 + Rs22;
end

% average error
wdavg_tra_error = wdsum_tra_error/runs;
wdavg_ref_error = wdsum_ref_error/runs;
wdavg_err1 = wdsum_err1/runs;
wdavg_err2 = wdsum_err2/runs;

% avg_Qs11 = sum_Qs11/runs;
% avg_Qs22 = sum_Qs22/runs;
avg_Rs11 = sum_Rs11/runs;
avg_Rs22 = sum_Rs22/runs;


wderr1 = cat(1, ini_err1, wdavg_err1);
wderr2 = cat(1, ini_err2, wdavg_err2);
wdtra_err = cat(1, ini_tra_err, wdavg_tra_error);
wdref_err = cat(1, ini_ref_err, wdavg_ref_error);


figure;
hold on
plot(1:length(avg_Rs11), avg_Rs11)
plot(1:length(avg_Rs22), avg_Rs22)
% plot(1:length(Qs11), Qs11)
% plot(1:length(Qs22), Qs22)
hold off
legend({'Rs11','Rs22'}, 'location', 'northeast')
xlabel('learning time')
ylabel('R')
title(['R parameters (wd, N = ' num2str(N) ', gamma = ' num2str(gamma_final) ' )'])


end

