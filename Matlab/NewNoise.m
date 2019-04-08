function [ proto_new ] = NewNoise(eta, protos, N, Q)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% N=100;    % dimension
% eta= 2;   % noise strength
f2 = 2*eta/N-eta^2/N/N;  % second term could be neglected for large n
w1 = protos(1,:);
w2 = protos(2,:);

% compute overlaps
% q11=dot(w1,w1);  
% q12=dot(w1,w2);     % q12 can be negative! 
% q22=dot(w2,w2); 
q11 = Q(1,1);
q22 = Q(2,2);
q12 = Q(1,2);

% three random vectors
n1 = null([w1;w2]);   % null-space orthogonal to w1 and w2
% d1 = size(n1,2); 
d1 = N-2; 
rc = rand(d1,1);  
% construct vector via random coefficients rc in null-space and normalize
r3 = (n1*rc)';   
r3 = r3/norm(r3)*sqrt(f2*abs(q12));
r3q= dot(r3,r3); 


n2 = null([w1;w2;r3]); % null-space orthogonal to w1,w2 and r3
% d2 = size(n2,2); 
d2 = N-3; 
rc = rand(d2,1); 
r1 = (n2*rc)'; 
r1 = r1/norm(r1)*sqrt(abs(f2*q11-r3q));


n3 = null([w1;w2;r3;r1]); 
% construct vector via random coefficients rc in null-space and normalize
% d3 = size(n3,2); 
d3 = N-4; 
rc = rand(d3,1);
r2 = (n3*rc)'; 
r2 = r2/norm(r2)*sqrt(abs(f2*q22-r3q)); 


% construct new student vectors
w1new = w1*(1-eta/N) + r1 + sign(q12)*r3;  
w2new = w2*(1-eta/N) + r2 +           r3; 

% w1new = abs(w1new);
% w2new = abs(w2new);

proto_new = [w1new; w2new];

% check required overlaps 
q11new= dot(w1new,w1new);
q12new= dot(w1new,w2new);
q22new= dot(w2new,w2new);

% if(0)
% r11 = dot(w1new,w1)/q11;  % should be 1-eta/n
% r12 = dot(w1new,w2)/q12;  % should be 1-eta/n
% r21 = dot(w2new,w1)/q12;  % should be 1-eta/n
% r22 = dot(w2new,w2)/q22;  % should be 1-eta/n
% end
%  

end

