function [ rand_data, rand_lbl ] = Generate_data(cls_ctrs, p1, prots, if_plot)
%ARTI_DATA Summary of this function goes here
%   Detailed explanation goes here
N = 2; % number of classes
Num_all = 500; % number of all the points

p2 = 1 - p1;
Num1 = round(p1 * Num_all);
Num2 = round(p2 * Num_all);
clt = [Num1 Num2]; % store the number of points each cluster

var = 0.4; % sigma for the normrnd spread
sigma = sqrt(var);
D = 0;

% feature vectors for the data and vector for the label
fvec = zeros(Num_all, D+2);
lbl = zeros(Num_all,1);

for i = 1:N
    S = clt(i); % number of points each class
    if i == 1
        rows = 1:S;
    else
        rows = clt(i-1)+1:clt(i-1)+S;
    end
    fvec(rows,1) = normrnd(cls_ctrs(i, 1), sigma, [S,1]); % first dim
    fvec(rows,2) = normrnd(cls_ctrs(i, 2), sigma, [S,1]); % second dim
    lbl(rows) = i;
end

% decide if plot figures or not
if if_plot == 1
   figure;
   hold on;
   sz = 20;
   
   for i = 1:N
       S = clt(i); % number of points each class
       if i == 1
           rows = 1:S;
       else
           rows = clt(i-1)+1:clt(i-1)+S;
       end
       scatter(fvec(rows,1), fvec(rows,2),sz, 'filled');
   end

   % plot prototypes
   gscatter([prots(1,1); prots(2,1)],[prots(1,2); prots(2,2)],[prots(1,3); prots(2,3)], 'mg', '..',25);
   xlim([-3 5])
   ylim([-3 5])
   hold off;
   legend(['p1=' num2str(p1)],['p2=' num2str(p2)])

end

%randomly select one datapoint at timestep t
rand_ind = randi(Num_all);
rand_data = fvec(rand_ind, :);
rand_lbl = lbl(rand_ind);

end

