function [ protos ] = Iniprotos( N )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% initialize cluster centres
proto1 = rand(1, N) - 0.5; 
proto1 = proto1/norm(proto1);

proto2 = rand(1, N) - 0.5; 
proto2 = proto2/norm(proto2);

protos = [proto1; proto2];

end

