% general parameters
a0 = 50;
a_end = 200;
p_max = 0.8;
L = 1;              % cluster drift distance
eta = 0.05;         % learning rate
N = 100;              % data dimention 
conti_ls = 1/N;     % continue learning step
tic;

% generate artificial dataset
[fvec, lbl] = Generate_data(cls_ctrs, prots);
lbl1_idx = find(lbl==1);
lbl2_idx = find(lbl==2);

% cluster centres (0,0) and (-L,L)
c1 = [0 ,L];
c2 = [L, 0];
cls_ctrs = [c1; c2];

% Initial prototypes
prots_feature = [c1; c2];
prots_lbl = [1;2];
prots = [prots_feature prots_lbl];

% Linear
p_init = 0.5;
[cls_p1, cls_p2] = Linear(a0, a_end, p_init, p_max);

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

% conti_ls = 20;
for t = 1:a_end
    current_p1 = cls_p1(t);
    data_label = Class_toss(current_p1);
    
%   randomly select one example with respect to the label
    if data_label == 1
        selected_data = fvec(randsample(lbl1_idx,1),:);
    elseif data_label == 2
        selected_data = fvec(randsample(lbl2_idx,1),:);
    end
   
    % use the randomly selected datapoint to update prots
    prots = LVQ1_algorithm(selected_data, data_label, prots, eta);
    proto1 = prots(1, 1:2);
    proto2 = prots(2, 1:2);
    protos_array = [protos_array; prots];
    
    % get generalization error
    [err1, err2, ref_err, tra_err] = Gerror(proto1, proto2, c1, c2, lambda, var1, var2, current_w1);
    err1_array = [err1_array; err1];
    err2_array = [err2_array; err2];
    ref_error_array = [ref_error_array; ref_err];
    tra_error_array = [tra_error_array; tra_err];
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
legend({'tracking error','ref error','error1','error2'})

time_total = toc;





