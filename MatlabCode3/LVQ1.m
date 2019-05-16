function [new_protos, Q] = LVQ1(example_new, example_label, protos, prots_lbl, lr, N, gamma)


num_prots = size(protos, 1);
data_dim = size(example_new, 2);

% calculate distance to all prototypes
dist_to_protos = zeros(num_prots, 1);

for j = 1:num_prots
    dist_to_protos(j) = Euc_dist(example_new, protos(j, 1:data_dim));        
end
[~, prot_idx] = min(dist_to_protos);


% get the label of the closest prototype
cls_proto_lbl = prots_lbl(prot_idx);


% update prototype
diff = example_new - protos(prot_idx,:);

if cls_proto_lbl == example_label
    protos(prot_idx, :) = (1-gamma/N)*protos(prot_idx, :)+ lr/N*diff;
else
    protos(prot_idx, :) = (1-gamma/N)*protos(prot_idx, :)- lr/N*diff;  
end   

new_protos = protos;
Q = new_protos * new_protos';
% R = old_protos * new_protos';

    
end