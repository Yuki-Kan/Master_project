% general parameters
a0 = 50;
a_end = 100;
p_max = 0.8;
L = 2; % cluster drift distance
eta = 0.01;

% cluster centres (0,0) and (-L,L)
c1 = [-L ,L];
c2 = [0, 0];
cls_ctrs = [c1; c2];

% Initial prototypes
prots_feature = [c1; c2];
prots_lbl = [1;2];
prots = [prots_feature prots_lbl];

% Linear
p_init = 0.5;
[cls_w1, cls_w2] = Linear(a0, a_end, p_init, p_max);

% % Sudden change
% p_max_sudden = 0.75;
% [cls_w1, cls_w2] = Sudden_Change(a0, a_end, p_max_sudden);
% 
% % Oscillating
% p_max_osc = 0.8;
% T = 50;
% [cls_w1, cls_w2] = Oscillation(p_max_osc, T, a_end);



% plot datapoints
plt_step = 20;
% at time step t, get p1(t) and p2(t)
protos_array = [];
for t = 1:a_end
    current_w1 = cls_w1(t);
    [selected_data, data_lable] = Generate_data(cls_ctrs, current_w1, prots);
   
    % use the randomly selected datapoint to update prots
    prots = LVQ1_algorithm(selected_data, data_lable, prots, eta);
    protos_array = [protos_array; prots];
end





