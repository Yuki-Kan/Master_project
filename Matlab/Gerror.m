function [err1, err2, ref_err, tra_err] = Gerror(proto1, proto2, c1, c2, lambda, var1, var2, p1, Q11, Q12, Q22 )
%Gerror Summary of this function goes here
%   Detailed explanation goes here

p2 = 1 - p1;

cent1 = c1/norm(c1);
cent2 = c2/norm(c2);

R11 = proto1 * cent1';
R12 = proto1 * cent2';
R21 = proto2 * cent1';
R22 = proto2 * cent2';

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


