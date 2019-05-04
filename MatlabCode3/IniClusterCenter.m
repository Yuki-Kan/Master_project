function [ cls_ctrs ] = IniClusterCenter( N )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% initialize cluster centres
c1 = rand(1, N) - 0.5; 
c1 = c1/norm(c1);
% null-space orthogonal to w1
nu1 = null(c1); 
dim1 = N-1;
% random coefficients
rc1 = rand(dim1,1) - 0.5; 
% construct new vector with random coefficients
c2 = (nu1*rc1)';
c2 = c2/norm(c2);
cls_ctrs = [c1; c2];


end

