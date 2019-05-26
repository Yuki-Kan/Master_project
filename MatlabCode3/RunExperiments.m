% run virtual drift under three scenarios respectively
clear
tic
% general parameters
N = 200;             % dimensions
lr = 10;              % learning rate
gamma = 0.1;           % weight decay
eta = 0.1;           % noise strength
runs = 20;            % running times
delta = 0.01;           % drifting class center

%%% Initial prototypes
iniprotos = Iniprotos(N);
clscenter = IniClusterCenter(N);


%% drift scenarios
%   idx = 1: Linear
%   idx = 2: Sudden change
%   idx = 3: Oscillation
input_scenario_idx = 1;
lschange = 50;      % change point
lstotal = 80;      % total learning steps
% p1 = DriftCase(input_scenario_idx, lschange, lstotal, N);
p1 = 0.7;


%% Experiments (virtual drift)
% [time_total, wdtra_err0, wdtra_err1, wdtra_err2, wdtra_err3,...
%  ntra_err1, ntra_err2, ntra_err3] = ConDrift(p1, lstotal, lr, N, gamma, eta, runs, delta);



%% Experiments (real drift)
Parray = 0:0.2:2;
AvgWd = [];
AvgNoise = [];
len = 100;

for p = 1: length(Parray)
    fprintf('%d\n',Parray(p));
    
    par = Parray(p);
    [wderr1, wderr2, wdtra_err, wdref_err] = ConDrift_wdecay(clscenter, iniprotos, p1, lstotal, N, runs, par, lr, delta);
    [nerr1, nerr2, ntra_err, nref_err] = ConDrift_noise(clscenter, iniprotos, p1, lstotal, N, runs, par, lr, delta);

    %%% average the result in the end
    [avgwderr1, avgwderr2, avgwdtra_err, avgwdref_err] = GetAvg(len, wderr1, wderr2, wdtra_err, wdref_err);
    [avgnerr1, avgnerr2, avgntra_err, avgnref_err] = GetAvg(len, nerr1, nerr2, ntra_err, nref_err);
    
    AvgWd = [AvgWd; avgwderr1, avgwderr2, avgwdtra_err, avgwdref_err];
    AvgNoise = [AvgNoise; avgnerr1, avgnerr2, avgntra_err, avgnref_err];
    
end

% load('results_N200__lr1_delta01_p0_p2.mat')

%% plot tracking error (RD)
AvgWdtra = AvgWd(:,3);
AvgNoisetra = AvgNoise(:,3);
Avglvqtra = mean([AvgWdtra(1) AvgNoisetra(1)]);
figure;
hold on
plot(Parray, Avglvqtra*ones(size(Parray)))
plot(Parray, AvgWdtra)
plot(Parray, AvgNoisetra)
hold off
ylim([0 0.5])
legend({'lvq1', 'w.d.', 'noise'}, 'location', 'northeast')
xlabel('gamma/eta')
ylabel('error')
title(['Tracking errors (lr=' num2str(lr) ', RD=' num2str(delta) ')'])

%% plot reference error (RD)
AvgWdref = AvgWd(:,4);
AvgNoiseref = AvgNoise(:,4);
Avglvqref = mean([AvgWdref(1) AvgNoiseref(1)]);
figure;
hold on
plot(Parray, Avglvqref*ones(size(Parray)))
plot(Parray, AvgWdref)
plot(Parray, AvgNoiseref)
hold off
ylim([0 0.8])
legend({'lvq1', 'w.d.', 'noise'}, 'location', 'northeast')
xlabel('gamma/eta')
ylabel('error')
title(['Reference errors (lr=' num2str(lr) ', RD=' num2str(delta) ')'])


%% plot error1 (RD)
AvgWd1 = AvgWd(:,1);
AvgNoise1 = AvgNoise(:,1);
Avglvq1 = mean([AvgWd1(1) AvgNoise1(1)]);
figure;
hold on
plot(Parray, Avglvq1*ones(size(Parray)))
plot(Parray, AvgWd1)
plot(Parray, AvgNoise1)
hold off
ylim([-0.5 0.5])
legend({'lvq1', 'w.d.', 'noise'}, 'location', 'northeast')
xlabel('gamma/eta')
ylabel('error')
title(['error 1 (lr=' num2str(lr) ', RD=' num2str(delta) ')'])



%% plot error2 (RD)
AvgWd2 = AvgWd(:,2);
AvgNoise2 = AvgNoise(:,2);
Avglvq2 = mean([AvgWd2(1) AvgNoise2(1)]);
figure;
hold on
plot(Parray, Avglvq2*ones(size(Parray)))
plot(Parray, AvgWd2)
plot(Parray, AvgNoise2)
hold off
ylim([0 2])
legend({'lvq1', 'w.d.', 'noise'}, 'location', 'northeast')
xlabel('gamma/eta')
ylabel('error')
title(['error 2 (lr=' num2str(lr) ', RD=' num2str(delta) ')'])

 
atime = toc;