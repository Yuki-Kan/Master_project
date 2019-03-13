function [err1, err2, ref_err, tra_err] = Gerror(all_protos, cls_ctrs, lambda, var1, var2, p1, Q )
%Gerror Summary of this function goes here
%   Detailed explanation goes here

p2 = 1 - p1;

Q11 = Q(1,1);
Q22 = Q(2,2);
Q12 = Q(1,2);

c1 = cls_ctrs(1, :);
c2 = cls_ctrs(2, :);
cent1 = c1/norm(c1);
cent2 = c2/norm(c2);

R = all_protos * cls_ctrs';
R11 = R(1,1);
R12 = R(1,2);
R21 = R(2,1);
R22 = R(2,2);

% k =1
num1 = Q11 - Q22 - 2 * lambda * (R11 - R21);
den1 = 2 * sqrt(var1) * sqrt(Q11 - 2*Q12 + Q22);
z1 = num1/den1;

% k =2
num2 = Q22 - Q11 - 2 * lambda * (R22 - R12);
den2 = 2 * sqrt(var2) * sqrt(Q11 - 2*Q12 + Q22);
z2 = num2/den2;

% perform integral
f = @(x) exp(-(x.^2)./2)./sqrt(2.*pi);
err1 = integral (f, -inf, z1);
err2 = integral (f, -inf, z2);

% tracking error
tra_err = p1 * err1 + p2 * err2;

% reference error
ref_err = (err1 + err2)/2;

end


