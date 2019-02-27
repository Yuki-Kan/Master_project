function [ output_args ] = Virtual_Drift( scenario_idx )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% general parameters
a0 = 50;
a_end = 200;
eta = 0.5;         % learning rate
N = 200;           % data dimention 
ls = 1/N;          % continue learning step
tic;

% initialize cluster centres
c1 = randn(1, N);
c1(1) = 0;
c1 = c1/norm(c1);
c2 = zeros(1, N);
c2(1) = 1;
cls_ctrs = [c1; c2];

% c1*c1'
% c2*c2'
% c1*c2'

% Initial prototypes
prots_feature = [c1; c2];
prots_lbl = [1;2];
prots = [prots_feature prots_lbl];

% generate artificial dataset
[fvec, lbl] = Generate_data(cls_ctrs, prots, N);
lbl1_idx = find(lbl==1);
lbl2_idx = find(lbl==2);

% initial parameters of three scenarios
p_init_linear = 0.5;  % Linear
p_max_linear = 0.8;
p_max_sudden = 0.75;  % Sudden change
p_max_osc = 0.8;      % Oscillating
T = 50;

switch scenario_idx
    case 1
        [cls_p1, cls_p2] = Linear(a0, a_end, p_init_linear, p_max_linear, ls);
    case 2
        [cls_p1, cls_p2] = Sudden_Change(a0, a_end, p_max_sudden, ls);
    case 3
        [cls_p1, cls_p2] = Oscillation(p_max_osc, T, a_end, ls);
end

% initial parameters of Generation error
lambda = 1; 
var1 = 0.4;
var2 = 0.4;

% at time step t, get p1(t) and p2(t)
protos_array = [];
tra_error_array = [];
ref_error_array = [];
err1_array = [];
err2_array = [];

% parameters of Gaussian distribution
var = 0.4; % sigma for the normrnd spread
sigma = sqrt(var);

i = 1;
for t = 1:ls:a_end 
    current_p1 = cls_p1(i);
    data_label = Class_toss(current_p1);
    
    % randomly generate new example based on the label
    new_data = normrnd(cls_ctrs(data_label, :), sigma, [1, N]); 

% %   randomly select one example with respect to the label
%     if data_label == 1
%         new_data = fvec(randsample(lbl1_idx,1),:);
%     elseif data_label == 2
%         new_data = fvec(randsample(lbl2_idx,1),:);
%     end

    % use the randomly selected datapoint to update prots
    prots = LVQ1_algorithm(new_data, data_label, prots, eta, N);
    proto1 = prots(1, 1:N);
    proto2 = prots(2, 1:N);
    
    % order parameters
    Q11 = proto1 * proto1';
    Q22 = proto2 * proto2';
    Q12 = proto1 * proto2';
    Q21 = proto2 * proto1';

    % get generalization error
    [err1, err2, ref_err, tra_err] = Gerror(proto1, proto2, c1, c2, lambda, var1, var2, current_p1, Q11, Q12, Q22);
    
    if rem(i,N)==0
        err1_array = [err1_array; err1];
        err2_array = [err2_array; err2];
        ref_error_array = [ref_error_array; ref_err];
        tra_error_array = [tra_error_array; tra_err];
    end

%     err1_array = [err1_array; err1];
%     err2_array = [err2_array; err2];
%     ref_error_array = [ref_error_array; ref_err];
%     tra_error_array = [tra_error_array; tra_err];

%     % add noise
%     [proto1_new, proto2_new] = AccuNoise(Q11, Q12, Q22, eta, N, proto1, proto2);
%     prots = [[proto1_new ; proto2_new] prots_lbl];
    
    i = i+1;
end

% plot tracking error and reference error
figure;
hold on
% plot(1:ls:a_end, tra_error_array);
% plot(1:ls:a_end, ref_error_array);
% plot(1:ls:a_end, err1_array)
% plot(1:ls:a_end, err2_array)

plot(1:a_end-1, tra_error_array);
plot(1:a_end-1, ref_error_array);
plot(1:a_end-1, err1_array)
plot(1:a_end-1, err2_array)
hold off
ylim([0 0.4])
legend({'tracking error','ref error','error1','error2'}, 'location', 'northwest')
xlabel('\alpha')
ylabel('\epsilon')


time_total = toc;


end

