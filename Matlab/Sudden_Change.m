function [ cls_w1 ] = Sudden_Change(a0, a_end, p_max_sudden, ls)
%SUDDEN_CHANGE Summary of this function goes here
%   Detailed explanation goes here
alpha = 0:ls:a_end-1;
len = length(alpha);
p1_sudden = zeros(1,len);
p2_sudden = zeros(1,len);
i = 1;

% for t <= t0
for t = 1:ls:a0
    p1_sudden(i) = p_max_sudden;
    p2_sudden(i) = 1 - p1_sudden(i);
    i = i+1;
end

i = i -1 ;
% for t0 <= t_end
for t = a0:ls:a_end
    p1_sudden(i) = 1- p_max_sudden;
    p2_sudden(i) = 1 - p1_sudden(i);
    i = i+1;
end

cls_w1 = p1_sudden;

figure;
plot(alpha, p1_sudden);
hold on
plot(alpha, p2_sudden);
xlim([0 200])
ylim([0 1])
hold off

legend('class-w1','class-w2')

end

