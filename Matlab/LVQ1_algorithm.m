function [updated_prots] = LVQ1_algorithm(current_data, data_lbl, current_prots, eta, N)

num_prots = size(current_prots, 1);
data_dim = size(current_data, 2);

% calculate distance to all prototypes
dist_to_protos = zeros(num_prots, 1);

for j = 1:num_prots
    dist_to_protos(j) = Euc_dist(current_data, current_prots(j, 1:data_dim));        
end
[val, prot_idx] = min(dist_to_protos);


% get the label of the closest prototype
cls_proto_lbl = current_prots(prot_idx, data_dim+1);


% update prototype
diff = [current_data(1:data_dim) 0] - [current_prots(prot_idx, 1:data_dim) 0];

if cls_proto_lbl == data_lbl
    current_prots(prot_idx, :) = current_prots(prot_idx, :)+ eta/N*diff;
else
    current_prots(prot_idx, :) = current_prots(prot_idx, :)- eta/N*diff;  
end   

updated_prots = current_prots;
    




end