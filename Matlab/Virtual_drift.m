function [ time_total ] = Virtual_Drift( scenario_idx, cls_ctrs, N)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% general parameters
a0 = 50;
a_end = 200;
lr = 0.5;          % learning rate
ls = 1/N;          % continue learning step
eta = 2;           % noise strength 
gamma = 0.05;      % strength of weight decay
runs = 20;         % running times
tic;

% c1*c1'
% c2*c2'
% c1*c2'

% Initial prototypes
protos = cls_ctrs;
prots_lbl = [1;2];
% [num_proto, d] = size(prots_lbl);

% % generate artificial dataset
% [fvec, lbl] = Generate_data(cls_ctrs, prots, N);
% lbl1_idx = find(lbl==1);
% lbl2_idx = find(lbl==2);

% initial parameters of three scenarios
p_init_linear = 0.5;  % Linear
p_max_linear = 0.8;
p_max_sudden = 0.75;  % Sudden change
p_max_osc = 0.8;      % Oscillating
T = 50;

switch scenario_idx
    case 1
        cls_p1 = Linear(a0, a_end, p_init_linear, p_max_linear, ls);
    case 2
        cls_p1 = Sudden_Change(a0, a_end, p_max_sudden, ls);
    case 3
        cls_p1 = Oscillation(p_max_osc, T, a_end, ls);
end

% initial parameters of Generation error
lambda = 1; 
var1 = 0.4;
var2 = 0.4;


sum_tra_error = zeros(a_end-1, 1);
sum_ref_error = zeros(a_end-1, 1);
sum_err1 = zeros(a_end-1, 1);
sum_err2 = zeros(a_end-1, 1);


% parameters for generating new example under Gaussian distribution
var = 0.4;  % sigma for the normrnd spread
sigma = sqrt(var);

for r = 1:runs
    fprintf('i: %d\n', r);
    
    % start one running phase
    % initialization
    tra_error_array = [];
    ref_error_array = [];
    err1_array = [];
    err2_array = [];
    i = 1;
    
    for t = 1:ls:a_end 
        % at time step t, get p1(t) and p2(t)
        current_p1 = cls_p1(i);
        example_label = Class_toss(current_p1);

        % randomly generate new example based on the label
        example_new = normrnd(cls_ctrs(example_label, :), sigma, [1, N]); 

    % %   randomly select one example with respect to the label
    %     if data_label == 1
    %         new_data = fvec(randsample(lbl1_idx,1),:);
    %     elseif data_label == 2
    %         new_data = fvec(randsample(lbl2_idx,1),:);
    %     end

%         % use the randomly selected datapoint to update prots
%         protos = LVQ1_algorithm(example_new, example_label, protos, prots_lbl, lr, N);

        % LVQ1 with weight decay
        protos = LVQ1_wdecay(example_new, example_label, protos, prots_lbl, lr, N, gamma);

        % order parameters
        Q = protos * protos';

    %     % add noise
    %     proto_new = NewNoise(eta, protos, N, Q);
    %     protos = real(proto_new);

        % get generalization error
        [err1, err2, ref_err, tra_err] = Gerror(protos, cls_ctrs, lambda, var1, var2, current_p1, Q);

        if rem(i,N)==0
            err1_array = [err1_array; err1];
            err2_array = [err2_array; err2];
            ref_error_array = [ref_error_array; ref_err];
            tra_error_array = [tra_error_array; tra_err];
        end

        i = i+1;
    end
    
    sum_tra_error = sum_tra_error + tra_error_array;
    sum_ref_error = sum_ref_error + ref_error_array;
    sum_err1 = sum_err1 + err1_array;
    sum_err2 = sum_err2 + err2_array;
end

% average error
avg_tra_error = sum_tra_error/runs;
avg_ref_error = sum_ref_error/runs;
avg_err1 = sum_err1/runs;
avg_err2 = sum_err2/runs;


% plot 
figure;
hold on

plot(1:length(avg_tra_error), avg_tra_error);
plot(1:length(avg_ref_error), avg_ref_error);
plot(1:length(avg_err1), avg_err1)
plot(1:length(avg_err2), avg_err2)

hold off
ylim([0 0.5])
title('Generalization errors')
legend({'tracking error','ref error','error1','error2'}, 'location', 'northwest')
xlabel('\alpha') 
ylabel('\epsilon')
time_total = toc;

end

