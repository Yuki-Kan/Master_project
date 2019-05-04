function [err1, err2, ref_err, tra_err] = Gerror(protos, cls_ctrs, lambda, var1, var2, current_p1, Q )
%Gerror Summary of this function goes here
%   Detailed explanation goes here

p2 = 1 - current_p1;

Q11 = Q(1,1);
Q22 = Q(2,2);
Q12 = Q(1,2);

Rc = protos * cls_ctrs';
Rc11 = Rc(1,1);
Rc12 = Rc(1,2);
Rc21 = Rc(2,1);
Rc22 = Rc(2,2);

% k =1
num1 = Q11 - Q22 - 2 * lambda * (Rc11 - Rc21);
den1 = 2 * sqrt(var1) * sqrt(Q11 - 2*Q12 + Q22);
z1 = num1/den1;
m1 = z1/sqrt(2);

% k =2
num2 = Q22 - Q11 - 2 * lambda * (Rc22 - Rc12);
den2 = 2 * sqrt(var2) * sqrt(Q11 - 2*Q12 + Q22);
z2 = num2/den2;
m2 = z2/sqrt(2); 

% error func
err1 = 1/2*(erf(m1)+1);
err2 = 1/2*(erf(m2)+1);

% tracking error
tra_err = current_p1 * err1 + p2 * err2;

% reference error
ref_err = (err1 + err2)/2;

end


