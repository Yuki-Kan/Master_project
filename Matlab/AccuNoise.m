function [proto1_new, proto2_new] = AccuNoise( Q11, Q12, Q22, eta, N, proto1, proto2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% random vector
r = rand(1, N);
r = r/norm(r);

syms a b c d e f
eqn1 = a*Q11 + b*Q12 + c*r*proto1' == 1-eta/N;  % w1_*w1 = 1-eta/N
eqn2 = a^2*Q11 + b^2*Q22 + c^2*r*r' + 2*a*b*Q12 + 2*a*c*r*proto1' + 2*a*c*r*proto2' == Q11; 
eqn3 = d*Q12 + e*Q22 + f*r*proto2'== 1-eta/N;
eqn4 = d^2*Q11 + e^2*Q22 + f^2*r*r' + 2*d*e*Q12 + 2*d*f*r*proto1' + 2*e*f*r*proto2' == Q22; 
eqn5 = a*d*Q11 + a*e*Q12 + (a*f+c*d)*r*proto1' + b*d*Q12 + b*e*Q22 + (b*f+c*e)*r*proto2'+ c*f*r*r' == Q12; 
eqns = [eqn1, eqn2, eqn3, eqn4, eqn5];
vars = [a b c d e f];
S1 = solve(eqns, vars);
sola = double(S1.a);
solb = double(S1.b);
solc = double(S1.c);
sold = double(S1.d);
sole = double(S1.e);
solf = double(S1.f);




% 
% syms a b 
% eqn1 = a*Q11+b*Q12 == 1-eta/N;
% eqn2 = a^2*Q11 + b^2*Q22 + 2*a*b*Q12==Q11;
% eqns1 = [eqn1, eqn2];
% vars1 = [a b];
% S1 = solve(eqns1, vars1);
% sola = double(S1.a);
% solb = double(S1.b);
% 
% random = randsample(2,1,true,[1 2]);
% proto1_new = sola(random)*proto1 + solb(random)*proto2;
% 
% 
% syms c d
% eqns2 = [c*Q12+d*Q22 == 1-eta/N, c^2*Q11 + d^2*Q22 + 2*c*d*Q12==Q22];
% vars2 = [c d];
% S2 = solve(eqns2, vars2);
% solc = double(S2.c);
% sold = double(S2.d);

% syms a b c d 
% eqns1 = [a*Q11+b*Q12 == 1-eta/N, ...
%          a^2*Q11 + b^2*Q22 + 2*a*b*Q12==Q11, ...
%          c*Q12+d*Q22 == 1-eta/N, ...
%          c^2*Q11 + d^2*Q22 + 2*c*d*Q12==Q22, ...
%          a*c*Q11 + a*d*Q12 + b*c*Q12 + b*d*Q22 == Q12];
% vars1 = [a b c d];
% S1 = solve(eqns1, vars1);
% sola = double(S1.a);
% solb = double(S1.b);
% solc = double(S2.c);
% sold = double(S2.d);

random = randsample(4,1);
a = real(sola(random, :));
b = real(solb(random, :));
c = real(solc(random, :));
d = real(sold(random, :));
e = real(sole(random, :));
f = real(solf(random, :));

proto1_new = a*proto1 + b*proto2 + c*r;
proto2_new = d*proto1 + e*proto2 + f*r;

% to test if q11 == Q11, q22 == Q22
q11 = proto1_new * proto1_new';
q22 = proto2_new * proto2_new';

q12 = proto1_new * proto2_new';
q21 = proto2_new * proto1_new';

end
