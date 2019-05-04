% data_a = importdata('data_lvq_A.mat');
% data_b = importdata('data_lvq_B.mat');
% 

% proto_n = [1 1];
% fvec = [data_a ; data_b];
% labels = [ones(size(data_a, 1), 1)*1; ones(size(data_b, 1), 1)*2];
% [lena, ~] = size(data_a);
% [lenb, ~] = size(data_b);
% [len, N] = size(fvec);

% c1*c1'
% c2*c2'
% c1*c2'

lr = 0.01;              % learning rate  
gamma = 0.05;
eta = 0.01;

len = 400;
N = 100;
c1 = rand(1, N); 
c1 = c1/norm(c1);
% null-space orthogonal to w1
nu1 = null(c1); 
dim1 = N-1;
% random coefficients
rc1 = rand(dim1,1); 
% construct new vector with random coefficients
c2 = (nu1*rc1)';
c2 = c2/norm(c2);
cls_ctrs = [c1; c2];
[fvec, labels] = Generate_data(cls_ctrs, N, len);

% generate prototypes
group_number = unique(labels);
cls_nb = length(group_number);
temp_merged = [fvec labels];
all_protos = [];
for i = 1:cls_nb
    class_data = temp_merged(temp_merged(:,N+1)==i, 1:N);
    rand_idx = randperm(200, 1);
    all_protos = [all_protos; [class_data(rand_idx, :) i]];
end


protos = all_protos(:, 1:N);
proto_label = [1; 2];
nb_prots = size(protos, 1);
epoch = 100;
sum_err = zeros(epoch, 1);
runs = 1;

for r = 1:runs
    fprintf('runs: %d\n', r);
    errors = zeros(epoch, 1);
    
    for ep = 1:epoch
        err_count = 0;
        % select one data point and update prototypes
        for idx = 1:len
            selected_example = fvec(idx,:);
            selected_label = labels(idx);

            % calculate distance to all prototypes
            dist_to_protos = zeros(nb_prots, 1);
            for j = 1:nb_prots
                dist_to_protos(j) = Euc_dist(selected_example, protos(j, :));        
            end
            [~, prot_idx] = min(dist_to_protos);

            % get the label of the closest prototype
            proto_lbl = proto_label(prot_idx);
            
            % order parameters
            Q = protos * protos';
            
            proto_new = NewNoise(eta, protos, N, Q);
            protos = proto_new;
            
            
            % update prototype
            diff = selected_example - protos(prot_idx,:);

            if proto_lbl == selected_label
                protos(prot_idx, :) = protos(prot_idx, :)*(1-gamma/N)+ lr*diff;
            else
                protos(prot_idx, :) = protos(prot_idx, :)*(1-gamma/N)- lr*diff;  
                err_count = err_count + 1;
            end     
        end

        % store the error of each epoch
        err = err_count/len;
        errors(ep, 1) = err;  
    end
    
    sum_err = sum_err + errors;
end

avg_err = sum_err/runs;
figure
plot(1:length(avg_err), avg_err)
axis([0 epoch 0 1])

