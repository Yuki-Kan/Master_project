function [ output_args ] = Euc_dist( X1, X2 )

% sum = 0;
% for i=1:length(X1)
%     sum = sum + (X1(i)-X2(i))^2;    
% end

output_args = dot(X1-X2, X1-X2);


end

