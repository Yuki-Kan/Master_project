function [ cls_w1, cls_w2 ] = Sudden_Change(a0, a_end, p_max_sudden)
%SUDDEN_CHANGE Summary of this function goes here
%   Detailed explanation goes here
alpha = 0:a_end-1;
p1_sudden = zeros(1,a_end);
p2_sudden = zeros(1,a_end);

% for t <= t0
for t = 1:a0
    p1_sudden(t) = p_max_sudden;
    p2_sudden(t) = 1 - p1_sudden(t);
end

% for t0 <= t_end
for t = a0:a_end
    p1_sudden(t) = 1- p_max_sudden;
    p2_sudden(t) = 1 - p1_sudden(t);
end

cls_w1 = p1_sudden;
cls_w2 = p2_sudden;

figure;
plot(alpha, p1_sudden);
hold on
plot(alpha, p2_sudden);
xlim([0 200])
ylim([0 1])
hold off

legend('class-w1','class-w2')

end

