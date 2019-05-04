function [ time_total ] = VirtualDrift(cls_p1, a_end, cls_ctrs, N, runs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tic
lr = 2;              % learning rate
gamma_final = 2;     % gamma
eta_final = 0.0005;   % eta

% used when increasing gamma from gamma_ini to gamma_final
gamma_ini = 0;
total_len = a_end*N;
gamma_step = (gamma_final-gamma_ini)/total_len;


% ===========================================
% experiments with weight decay
[wderr1, wderr2, wdtra_err, wdref_err] = VirtualDrift_wdecay(cls_p1, a_end, cls_ctrs, N, runs, gamma_final, lr);
% no weight decay, gamma = 0
% [wderr1, wderr2, wdtra_err0, wdref_err] = VirtualDrift_wdecay(cls_p1, a_end, cls_ctrs, N, runs, 0, lr);


% ===========================================
% experiments with noise
[nerr1, nerr2, ntra_err, nref_err] = VirtualDrift_noise(cls_p1, a_end, cls_ctrs, N, runs, eta_final, lr);



% ============================================
% plot 
figure;
hold on

% plot(1:length(avg_tra_error), avg_tra_error); 
% plot(1:length(avg_ref_error), avg_ref_error);
% plot(1:length(avg_err1), avg_err1)
% plot(1:length(avg_err2), avg_err2)

% plot(1:ls:a_end, avg_tra_error); 
% plot(1:ls:a_end, avg_ref_error);
% plot(1:ls:a_end, avg_err1)
% plot(1:ls:a_end, avg_err2)

% step_array = 0:gamma_step:gamma_final;
step_array = 0:1/N:a_end;
% plot(step_array, wderr1)
% plot(step_array, wderr2)
% plot(step_array, wdtra_err0, 'g')
plot(step_array, wdtra_err)
% plot(step_array, wdref_err)

% step_array2 = 0:eta_step:eta ;
% step_array = 0:1/N:a_end;
% plot(step_array, nerr1) 
% plot(step_array, nerr2)
plot(step_array, ntra_err)
% plot(step_array, nref_err)

% step = 0:1/N:a_end;
% plot(step, wdtra_err)
% plot(step, ntra_err)

% plot(0:lr_step:lr, avg_tra_error); 
% plot(0:lr_step:lr, avg_ref_error);
% plot(0:lr_step:lr, avg_err1)
% plot(0:lr_step:lr, avg_err2)

hold off
ylim([0 0.6])
% legend({'error1','error2','tracking error','ref error'}, 'location', 'northeast')
% xlabel('learning step')
% ylabel('\epsilon')
% title(['drift1 with noise( lr=' num2str(lr) ', N=' num2str(N) ...
%        ', eta=' num2str(eta_final) ')'])

% xlabel('\eta')
% ylabel('\epsilon')
% title(['LVQ1 with noise ( lr=' num2str(lr) ', N=' num2str(N) ')'])


legend({'weight decay','noise'}, 'location', 'northeast')
xlabel('learning time')
ylabel('tracking error')
title(['No Drift ( lr=' num2str(lr) ', N=' num2str(N) ...
       ', gamma=' num2str(gamma_final)...
       ', eta=' num2str(eta_final) ')'])

% if eta
%     title(['Generalization errors (noise ' num2str(eta) ' lr ' num2str(lr) ')'])
% elseif gamma
%     title(['Generalization errors (gamma ' num2str(gamma) ' lr ' num2str(lr) ')'])
% else
%     title('Generalization errors (original LVQ1)')
% end

time_total = toc;

end

