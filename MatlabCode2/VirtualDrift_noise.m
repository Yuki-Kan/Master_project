function [nerr1, nerr2, ntra_err, nref_err] = VirtualDrift_noise(cls_p1, a_end, cls_ctrs, N, runs, eta_final, lr)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% general parameters
ls = 1/N;             % continue learning step

% Initial prototypes
protos = Iniprotos(N);
% protos = cls_ctrs;
prots_lbl = [1;2];


% parameters of Generation errors
lambda = 1; 
var1 = 0.4;
var2 = 0.4;


% Initial error at time 0, no training yet
Q = protos * protos';
ini_p1 = 0.5;
[ini_err1, ini_err2, ini_ref_err, ini_tra_err] = Gerror(protos, cls_ctrs, lambda, var1, var2, ini_p1, Q); 


% parameters for generating new example under Gaussian distribution
var = 0.4;           % sigma for the normrnd spread
sigma = sqrt(var);


total_len = a_end*N;
nsum_tra_error = zeros(total_len, 1);
nsum_ref_error = zeros(total_len, 1);
nsum_err1 = zeros(total_len, 1);
nsum_err2 = zeros(total_len, 1);

% used when increasing gamma
eta = 0;            
eta_step = (eta_final-eta)/total_len;

for r = 1:runs
    fprintf('noise runs: %d\n', r);

    tra_error_n = [];
    ref_error_n = [];
    err1_n = [];
    err2_n = [];
    
    Qs12 = [];
    Qs21 = [];
    Rs12 = [];
    Rs21 = [];
    
    i = 1;
    % eta = 0;
    
    for t = ls:ls:a_end 
        % at time step t, get p1(t) and p2(t)
        % current_p1 = cls_p1(i);
        current_p1 = cls_p1;
        example_label = Class_toss(current_p1);

        % generate new example based on the label
        example_new = normrnd(cls_ctrs(example_label, :), sigma, [1, N]); 

        % LVQ1
        protos0 = LVQ1_alg(example_new, example_label, protos, prots_lbl, lr, N);
        % protos0 = protos;  % no training
        
        % add noise
        % eta = eta + eta_step;       % increasing eta
        eta = eta_final;              % constant eta
        proto_new = NewNoiseStep(eta, protos0, N);
        protos = proto_new;
        
        % add this in order to plot Q and R, only for one run
        Q = proto_new * proto_new';
        Q12 = Q(1,2);
        Q21 = Q(2,1);
        Qs12 = [Qs12; Q12];
        Qs21 = [Qs21; Q21];
        
        R = protos0 * proto_new';
        R12 = R(1,2);
        R21 = R(2,1);
        Rs12 = [Rs12; R12];
        Rs21 = [Rs21; R21];
        
%         if ~isreal(protos)
%             break;
%         end
        
        % get generalization errors
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


nerr1 = cat(1, ini_err1, n_avg_err1);
nerr2 = cat(1, ini_err2, n_avg_err2);
ntra_err = cat(1, ini_tra_err, n_avg_tra_error);
nref_err = cat(1, ini_ref_err, n_avg_ref_error);


% figure;
% hold on
% plot(1:length(Rs12), Rs12)
% plot(1:length(Rs21), Rs21)
% plot(1:length(Qs12), Qs12)
% plot(1:length(Qs21), Qs21)
% hold off
% legend({'Rs21','Rs12', 'Qs12', 'Qs21'}, 'location', 'northeast')
% xlabel('learning time')
% ylabel('R and Q')
% title(['Q and R (wd, noise, N = ' num2str(N) ', eta = ' num2str(eta_final) ' )'])


end

