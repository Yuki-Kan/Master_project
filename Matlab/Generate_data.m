function [fvec, lbl] = Generate_data(cls_ctrs, N, Num_all)
%ARTI_DATA Summary of this function goes here
%   Detailed explanation goes here
C = 2; % number of classes

% p2 = 1 - p1;
p = 0.5; 
Num1 = round(p * Num_all);
Num2 = round(p * Num_all);
clt = [Num1 Num2]; % store the number of points each cluster

var = 0.4; % sigma for the normrnd spread
sigma = sqrt(var);

% feature vectors for the data and vector for the label
fvec = zeros(Num_all, N);
lbl = zeros(Num_all,1);

for i = 1:C
    S = clt(i); % number of points each class
    rows = (i-1)*S+1:i*S;
    for j = 1:N
        fvec(rows,j) = normrnd(cls_ctrs(i, j), sigma, [S,1]); 
    end
    lbl(rows) = i;
end

% PROJECTION

figure;
hold on;
sz = 20;

for i = 1:C
   S = clt(i); % number of points each class
   rows = (i-1)*S+1:i*S;
   scatter(fvec(rows,1), fvec(rows,2),sz, 'filled');
end

% plot prototypes
% gscatter([prots(1,1); prots(2,1)],[prots(1,2); prots(2,2)],[prots(1,N+1); prots(2,N+1)], 'mg', '..',25);
xlim([-3 5])
ylim([-3 5])
hold off;
%    legend(['p1=' num2str(p1)],['p2=' num2str(p2)])
legend('class1', 'class2')



% %randomly select one datapoint at timestep t
% rand_ind = randi(Num_all);
% rand_data = fvec(rand_ind, :);
% rand_lbl = lbl(rand_ind);

end

