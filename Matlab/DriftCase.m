function [ cls_p1 ] = DriftCase( input_scenario_idx, a_mid, a_end, N)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

p_init_linear = 0.5;  % Linear
p_max_linear = 0.8;
p_max_sudden = 0.75;  % Sudden change
p_max_osc = 0.8;      % Oscillating
T = 50;
ls = 1/N;             % continue learning step


switch input_scenario_idx
    case 1
        cls_p1 = Linear(a_mid, a_end, p_init_linear, p_max_linear, ls);
    case 2
        cls_p1 = SuddenChange(a_mid, a_end, p_max_sudden, ls);
    case 3
        cls_p1 = Oscillation(p_max_osc, T, a_end, ls);
end



end

