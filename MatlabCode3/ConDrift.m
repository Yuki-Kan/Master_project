function [time_total] = ConDrift(p1, lstotal, lr, N, gamma, eta, runs, delta)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

tic

% Initial prototypes
iniprotos = Iniprotos(N);
clscenter = IniClusterCenter(N);

% Experiments 
[wderr01, wderr02, wdtra_err0, wdref_err0] = ConDrift_wdecay(clscenter, iniprotos, p1, lstotal, N, runs, 0, lr, delta);
[wderr11, wderr12, wdtra_err1, wdref_err1] = ConDrift_wdecay(clscenter, iniprotos, p1, lstotal, N, runs, gamma, lr, delta);
[nerr11, nerr12, ntra_err1, nref_err1] = ConDrift_noise(clscenter, iniprotos, p1, lstotal, N, runs, eta, lr, delta);


%%% ============= plot figures below ======================================
%%% ============= figure for tracking error ===============================
figure;
hold on
step_array = 0:1/N:lstotal;
plot(step_array, wdtra_err0, 'g')
plot(step_array, wdtra_err1)
plot(step_array, ntra_err1)


hold off
ylim([0.1 0.7])
legend({'\gamma=0', '\gamma = 0.1', '\gamma= 0.5', '\gamma = 1', ...
        '\eta = 0.1', '\eta = 0.5', '\eta = 1' }, 'location', 'northeast')
xlabel('learning time')
ylabel('tracking error')
title(['Tracking errors (lr=' num2str(lr) ', N=' num2str(N) ', p1=' num2str(p1) ', delta=' num2str(delta) ')'])

   
   
% %%% ============= figure for reference error ==============================
% % plot 
% figure;
% hold on
% step_array = 0:1/N:lstotal;
% plot(step_array, wdref_err0, 'g')
% plot(step_array, wdref_err)
% plot(step_array, nref_err)
% hold off
% ylim([0 0.6])
% legend({'LVQ1', 'Wdecay','Noise'}, 'location', 'northeast')
% xlabel('learning time')
% ylabel('reference error')
% title(['Reference errors (lr=' num2str(lr) ', N=' num2str(N) ...
%        ', gamma=' num2str(gamma_final)...
%        ', eta=' num2str(eta_final) ')'])
% 
%  
%    
% %%% ============= figure for lvq1 without wdcay ============================
% figure;
% hold on
% step_array = 0:1/N:lstotal;
% plot(step_array, wderr01)
% plot(step_array, wderr02)
% plot(step_array, wdtra_err0)
% plot(step_array, wdref_err0)
% hold off
% % ylim([0 0.6])
% legend({'error1','error2','tracking error','ref error'}, 'location', 'northeast')
% xlabel('learning step')
% ylabel('\epsilon')
% title(['LVQ1 (lr=' num2str(lr) ', N=' num2str(N) ...
%        ', gamma=' num2str(0) ')'])
%    
%    
% 
% %%% ============= figure for wdecay =======================================
% figure;
% hold on
% step_array = 0:1/N:lstotal;
% plot(step_array, wderr11)
% plot(step_array, wderr12)
% plot(step_array, wdtra_err1)
% plot(step_array, wdref_err1)
% hold off
% % ylim([0 0.6])
% legend({'error1','error2','tracking error','ref error'}, 'location', 'northeast')
% xlabel('learning step')
% ylabel('\epsilon')
% title(['Wdecay (lr=' num2str(lr) ', N=' num2str(N) ...
%        ', gamma=' num2str(gamma) ')'])
% 
% 
%    
% %%% ============= figure for noise ========================================
% figure;
% hold on
% step_array = 0:1/N:lstotal;
% plot(step_array, nerr11) 
% plot(step_array, nerr12)
% plot(step_array, ntra_err1)
% plot(step_array, nref_err1)
% hold off
% % ylim([0 0.6])
% legend({'error1','error2','tracking error','ref error'}, 'location', 'northeast')
% xlabel('learning step')
% ylabel('\epsilon')
% title(['Noise( lr=' num2str(lr) ', N=' num2str(N) ...
%        ', eta=' num2str(eta) ')'])
% 



time_total = toc;

end

