% general parameters
a0 = 25;
a_end = 50;
p_max = 0.8;
L = 1;              % cluster drift distance
eta = 0.05;         % learning rate
N = 5;              % data dimention 
ls = 1/N;     % continue learning step
tic;

% initialize cluster centres
c1 = zeros(1,N);
c2 = zeros(1,N);
c1(1) = 1;
c2(2) = 1;
cls_ctrs = [c1; c2];

% Initial prototypes
prots_feature = [c1; c2];
prots_lbl = [1;2];
prots = [prots_feature prots_lbl];

% generate artificial dataset
[fvec, lbl] = Generate_data(cls_ctrs, prots, N);
lbl1_idx = find(lbl==1);
lbl2_idx = find(lbl==2);

% Linear
p_init = 0.5;
[cls_p1, cls_p2] = Linear(a0, a_end, p_init, p_max, ls);

% % Sudden change
% p_max_sudden = 0.75;
% [cls_w1, cls_w2] = Sudden_Change(a0, a_end, p_max_sudden);

% % Oscillating
% p_max_osc = 0.8;
% T = 50;
% [cls_w1, cls_w2] = Oscillation(p_max_osc, T, a_end);

% Parameters for Generation error
lambda = 1; 
var1 = 0.4;
var2 = 0.4;

% at time step t, get p1(t) and p2(t)
protos_array = [];
tra_error_array = [];
ref_error_array = [];
err1_array = [];
err2_array = [];

i = 1;
% conti_ls = 20;
for t = 1:ls:a_end 
    current_p1 = cls_p1(i);
    data_label = Class_toss(current_p1);

%   randomly select one example with respect to the label
    if data_label == 1
        selected_data = fvec(randsample(lbl1_idx,1),:);
    elseif data_label == 2
        selected_data = fvec(randsample(lbl2_idx,1),:);
    end

    % use the randomly selected datapoint to update prots
    prots = LVQ1_algorithm(selected_data, data_label, prots, eta);
    proto1 = prots(1, 1:N);
    proto2 = prots(2, 1:N);
%     protos_array = [protos_array; prots];

    % get generalization error
    [err1, err2, ref_err, tra_err] = Gerror(proto1, proto2, c1, c2, lambda, var1, var2, current_p1);
    err1_array = [err1_array; err1];
    err2_array = [err2_array; err2];
    ref_error_array = [ref_error_array; ref_err];
    tra_error_array = [tra_error_array; tra_err];
    
    i = i+1;
end


tra_err_array = double(tra_error_array);
ref_err_array = double(ref_error_array);
gerr1_array = double(err1_array);
gerr2_array = double(err2_array);

% plot tracking error and reference error
figure;
hold on
plot(1:a_end, tra_err_array,'-*','MarkerSize',4);
plot(1:a_end, ref_err_array,'-x','MarkerSize',4);
plot(1:a_end, gerr1_array)
plot(1:a_end, gerr2_array)
hold off
ylim([0 0.3])
legend({'tracking error','ref error','error1','er ror2'})

time_total = toc;





