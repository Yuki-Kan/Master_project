function [ time_total ] = VirtualDrift(p1, lstotal, lr, N, gamma, eta,runs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tic
gamma_final = gamma;
eta_final = eta;      

% used for increasing gamma
gamma_ini = 0;
total_len = lstotal*N;
gamma_step = (gamma_final-gamma_ini)/total_len;


%%% Initial prototypes
% protos_initial = IniClusterCenter(N);
iniprotos = Iniprotos(N);
cls_ctrs = IniClusterCenter(N);

%%% Experiments 
% lvq1 withot wdecay, gamma=0
[wderr01, wderr02, wdtra_err0, wdref_err0] = VirtualDrift_wdecay(cls_ctrs, iniprotos, p1, lstotal, N, runs, 0, lr);
% with weight decay 
[wderr1, wderr2, wdtra_err, wdref_err] = VirtualDrift_wdecay(cls_ctrs, iniprotos, p1, lstotal, N, runs, gamma_final, lr);
% with noise 
[nerr1, nerr2, ntra_err, nref_err] = VirtualDrift_noise(cls_ctrs, iniprotos, p1, lstotal, N, runs, eta_final, lr);


%%% ============= plot figures below ======================================
%%% ============= figure for tracking error ===============================
figure;
hold on
% plot(1:ls:a_end, avg_tra_error); 
% plot(1:ls:a_end, avg_ref_error);
% plot(1:ls:a_end, avg_err1)
% plot(1:ls:a_end, avg_err2)

% step_array = 0:gamma_step:gamma_final;
step_array = 0:1/N:lstotal;
plot(step_array, wdtra_err0, 'g')
plot(step_array, wdtra_err)
plot(step_array, ntra_err)

% plot(0:lr_step:lr, avg_tra_error); 
% plot(0:lr_step:lr, avg_ref_error);
% plot(0:lr_step:lr, avg_err1)
% plot(0:lr_step:lr, avg_err2)

hold off
ylim([0 0.6])
legend({'LVQ1', 'Wdecay','Noise'}, 'location', 'northeast')
xlabel('learning time')
ylabel('tracking error')
title(['Tracking errors ( lr=' num2str(lr) ', N=' num2str(N) ...
       ', gamma=' num2str(gamma_final)...
       ', eta=' num2str(eta_final) ')'])

   
   
%%% ============= figure for reference error ==============================
% plot 
figure;
hold on
step_array = 0:1/N:lstotal;
plot(step_array, wdref_err0, 'g')
plot(step_array, wdref_err)
plot(step_array, nref_err)
hold off
ylim([0 0.6])
legend({'LVQ1', 'Wdecay','Noise'}, 'location', 'northeast')
xlabel('learning time')
ylabel('reference error')
title(['Reference errors ( lr=' num2str(lr) ', N=' num2str(N) ...
       ', gamma=' num2str(gamma_final)...
       ', eta=' num2str(eta_final) ')'])

 
   
%%% ============= figure for lvq1 withou wdcay ============================
figure;
hold on
step_array = 0:1/N:lstotal;
plot(step_array, wderr01)
plot(step_array, wderr02)
plot(step_array, wdtra_err0)
plot(step_array, wdref_err0)
hold off
ylim([0 0.6])
legend({'error1','error2','tracking error','ref error'}, 'location', 'northeast')
xlabel('learning step')
ylabel('\epsilon')
title(['Drift3 ( lr=' num2str(lr) ', N=' num2str(N) ...
       ', gamma=' num2str(0) ')'])
   
   

%%% ============= figure for wdecay =======================================
figure;
hold on
step_array = 0:1/N:lstotal;
plot(step_array, wderr1)
plot(step_array, wderr2)
plot(step_array, wdtra_err)
plot(step_array, wdref_err)
hold off
ylim([0 0.6])
legend({'error1','error2','tracking error','ref error'}, 'location', 'northeast')
xlabel('learning step')
ylabel('\epsilon')
title(['Drift3 with wdecay( lr=' num2str(lr) ', N=' num2str(N) ...
       ', gamma=' num2str(gamma_final) ')'])

   
   
%%% ============= figure for noise ========================================
figure;
hold on
step_array = 0:1/N:lstotal;
plot(step_array, nerr1) 
plot(step_array, nerr2)
plot(step_array, ntra_err)
plot(step_array, nref_err)
hold off
ylim([0 0.6])
legend({'error1','error2','tracking error','ref error'}, 'location', 'northeast')
xlabel('learning step')
ylabel('\epsilon')
title(['Drift3 with noise( lr=' num2str(lr) ', N=' num2str(N) ...
       ', eta=' num2str(eta_final) ')'])




time_total = toc;

end

