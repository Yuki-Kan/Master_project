%% Linear increse
t0 = 25;
t_end = 200;
p_int = 0.5;
p_max = 0.8;

x = 0:t_end-1;
p1 = zeros(1,t_end);
p2 = zeros(1,t_end);

% for t <= t0
for t = 1:t0
    p1(t) = p_int;
    p2(t) = 1 - p1(t);
end

% for t0 <= t_end
for t = t0:t_end
    p1(t) = p_int + (p_max - p_int)* (t-t0) /(t_end - t0);
    p2(t) = 1 - p1(t);
end

figure;
plot(x, p1);
hold on
plot(x, p2);
xlim([0 200])
ylim([0 1])

%% Sudden change
p_max_sudden = 0.75;
p1_sudden = zeros(1,t_end);
p2_sudden = zeros(1,t_end);

% for t <= t0
for t = 1:t0
    p1_sudden(t) = p_max_sudden;
    p2_sudden(t) = 1 - p1_sudden(t);
end

% for t0 <= t_end
for t = t0:t_end
    p1_sudden(t) = 1- p_max_sudden;
    p2_sudden(t) = 1 - p1_sudden(t);
end

figure;
plot(x, p1_sudden);
hold on
plot(x, p2_sudden);
xlim([0 200])
ylim([0 1])
