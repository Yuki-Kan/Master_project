function [avgError1, avgError2, avgError3, avgError4] = GetAvg( length, error1, error2, error3, error4)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


avgError1 = mean(error1(end-length+1:end));
avgError2 = mean(error2(end-length+1:end));
avgError3 = mean(error3(end-length+1:end));
avgError4 = mean(error4(end-length+1:end));



end

