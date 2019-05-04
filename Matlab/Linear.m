function [cls_w1] = Linear( a_mid, a_end, p_init_linear, p_max_linear, ls)
%CLASS_WEIGHTS Summary of this function goes here
%   Detailed explanation goes here

alpha = 1:ls:a_end;
len = length(alpha);
p1 = zeros(1,len);
p2 = zeros(1,len);
i = 1;


% for t <= t0
for t = 1:ls:a_mid
    p1(i) = p_init_linear;
    p2(i) = 1 - p1(i);
    i = i +1;
end

i = i -1 ;
% for t0 <= t_end
for t = a_mid:ls:a_end
    p1(i) = p_init_linear + (p_max_linear - p_init_linear)* (t-a_mid) /(a_end - a_mid);
    p2(i) = 1 - p1(i);
    i = i+1;
end

cls_w1 = p1;

figure;
plot(alpha, p1);
hold on
plot(alpha, p2);
xlim([0 a_end])
ylim([0 1])
title('Linear change')
hold off

legend('class-w1','class-w2')

end

