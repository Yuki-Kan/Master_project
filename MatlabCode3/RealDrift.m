function [ clscenter_new ] = RealDrift( N, delta, clscenter )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% % which should be commented later
% N = 100;  
% delta = 0.1;
% clscenter = IniClusterCenter(N);

% real drift
f2 = 2*delta/N -delta^2/N/N;
b1 = clscenter(1,:);
b2 = clscenter(2,:);

% two random vectors
n1 = null([b1;b2]);   % null-space orthogonal to w1 and w2
d1 = size(n1,2); 
rc = rand(d1,1)-0.5;  
% construct vector via random coefficients rc in null-space and normalize
r1 = (n1*rc)';   
r1 = r1/norm(r1)*sqrt(f2);


n2 = null([b1;b2;r1]); % null-space orthogonal to w1,w2 and r1
d2 = size(n2,2); 
rc = rand(d2,1)-0.5; 
r2 = (n2*rc)'; 
r2 = r2/norm(r2)*sqrt(f2); 


% construct new cluster centers
b1new = b1*(1-delta/N) + r1;  
b2new = b2*(1-delta/N) + r2; 
clscenter_new = [b1new; b2new];

% % check required conditions
% dot(b1,b1)
% dot(b2,b2)
% dot(b1,b2)
% dot(b1new,b1new)
% dot(b2new,b2new)
% dot(b1new,b2new)
% dot(b1,b1new)
% dot(b2,b2new)

end

