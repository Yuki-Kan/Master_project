function [cls_w1, cls_w2] = Linear( a0, a_end, p_init, p_max)
%CLASS_WEIGHTS Summary of this function goes here
%   Detailed explanation goes here

alpha = 0:a_end-1;
p1 = zeros(1,a_end);
p2 = zeros(1,a_end);

% for t <= t0
for t = 1:a0
    p1(t) = p_init;
    p2(t) = 1 - p1(t);
end

% for t0 <= t_end
for t = a0:a_end
    p1(t) = p_init + (p_max - p_init)* (t-a0) /(a_end - a0);
    p2(t) = 1 - p1(t);
end

cls_w1 = p1;
cls_w2 = p2;

figure;
plot(alpha, p1);
hold on
plot(alpha, p2);
xlim([0 a_end])
ylim([0 1])
hold off

legend('class-w1','class-w2')

end

