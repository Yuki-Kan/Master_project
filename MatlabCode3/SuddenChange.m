function [ cls_w1 ] = SuddenChange(a_mid, a_end, pmax_sudden, ls)
%SUDDEN_CHANGE Summary of this function goes here
%   Detailed explanation goes here

alpha = ls:ls:a_end;
len = length(alpha);
p1_sudden = zeros(1,len);
p2_sudden = zeros(1,len);
i = 1;

% for t <= t0
for t = ls:ls:a_mid
    p1_sudden(i) = pmax_sudden;
    p2_sudden(i) = 1 - p1_sudden(i);
    i = i+1;
end

i = i -1 ;
% for t0 <= t_end
for t = a_mid:ls:a_end
    p1_sudden(i) = 1- pmax_sudden;
    p2_sudden(i) = 1 - p1_sudden(i);
    i = i+1;
end

cls_w1 = p1_sudden;

figure;
plot(alpha, p1_sudden);
hold on
plot(alpha, p2_sudden);
xlim([0 a_end])
ylim([0 1])
title('Sudden change')
hold off
legend('class-w1','class-w2')

end

