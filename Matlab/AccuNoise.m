function [proto1_new, proto2_new] = AccuNoise( Q11, Q12, Q22, eta, N, proto1, proto2)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

syms a b 
eqns1 = [a*Q11+b*Q12 == 1-eta/N, a^2*Q11 + b^2*Q22 + 2*a*b*Q12==Q11];
vars1 = [a b];
S1 = solve(eqns1, vars1);
sola = double(S1.a);
solb = double(S1.b);

random = randsample(2,1,true,[1 2]);
proto1_new = sola(random)*proto1 + solb(random)*proto2;


syms c d
eqns2 = [c*Q12+d*Q22 == 1-eta/N, c^2*Q11 + d^2*Q22 + 2*c*d*Q12==Q22];
vars2 = [c d];
S2 = solve(eqns2, vars2);
solc = double(S2.c);
sold = double(S2.d);

proto2_new = solc(random)*proto1 + sold(random)*proto2;

% to test if q11 == Q11, q22 == Q22
q11 = proto1_new * proto1_new';
q22 = proto2_new * proto2_new';

end
