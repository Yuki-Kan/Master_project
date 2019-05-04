function [ cls_p1 ] = DriftCase(input_scenario_idx, lschange, lstotal, N)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

pint_linear = 0.5;   % Linear
pmax_linear = 0.8;
pmax_sudden = 0.75;  % Sudden change
pmax_osc = 0.8;      % Oscillating
T = 50;
ls = 1/N;            % continue learning step


switch input_scenario_idx
    case 1
        cls_p1 = Linear(lschange, lstotal, pint_linear, pmax_linear, ls);
    case 2
        cls_p1 = SuddenChange(lschange, lstotal, pmax_sudden, ls);
    case 3
        cls_p1 = Oscillation(pmax_osc, T, lstotal, ls);
end



end

