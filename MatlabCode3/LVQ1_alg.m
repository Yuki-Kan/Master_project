function [new_protos] = LVQ1_alg(example_new, example_label, protos, prots_lbl, lr, N)

old_protos = protos;
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
    protos(prot_idx, :) = protos(prot_idx, :)+ lr/N*diff;
else
    protos(prot_idx, :) = protos(prot_idx, :)- lr/N*diff;  
end   

new_protos = protos;

end