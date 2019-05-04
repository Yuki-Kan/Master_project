function [cls_w1] = Oscillation(p_max_osc, T, StopTime,ls)
%%Time specifications:
% Fs = 1;                 % samples per second
% dt = 1/Fs;                % seconds per samples
t = ls:ls:StopTime;     % seconds

fc = 1/T;
p1 = 0.5+(p_max_osc-0.5)*cos(2*pi*fc*t);
p2 = 1-p1;

cls_w1 = p1;

figure;
plot(t, p1)
hold on
plot(t, p2)
ylim([0 1])
title('Oscillation')
hold off

end


