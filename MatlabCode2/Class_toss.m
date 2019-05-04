function [ random_label ] = Class_toss(p1)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

p2 = 1-p1;
random_label = randsample(2,1,true,[p1 p2]);

end

