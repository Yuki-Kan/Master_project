function [proto_new] = AccuNoise(Q, eta, N, all_protos)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

R = Q * (1-eta/N);

% the number of old and new prototypes
[M, ~] = size(all_protos);   
[K, dim] = size(all_protos);

B = all_protos';

J = Noise_Solver(Q, R, B, K, M, dim);

% test Q and R
% q = J'*J;
% r = all_protos * J;
% R
% r
% Q
% q

proto_new = J';

% % random vector
% r1 = rand(1, N);
% r1 = r1/norm(r1);
% r2 = rand(1, N);
% r2 = r2/norm(r2);

%===========================================
% M = [all_protos; r1];
% J = M*all_protos';
% [Jsize, Jdim] = size(J);
% 
% % Overlapping between old and new prototypes
% R = Q * (1-eta/N);
% 
% a = sym('a', [1,3]);
% b = sym('b', [1,3]);
% syms eqns;
% eqns(1) = [];
% 
% U = [a; b];
% eq = U*J;
% for i = 1:2
%     for j = 1:2
%         eqns(end+1) = eq(i,j)==R(i,j);
%     end
% end
% 
% S = M*M';
% eq2 = U*S*U';
% for i = 1:2
%     for j = 1:2
%         eqns(end+1) = eq2(i,j)==Q(i,j);
%     end
% end
% 
% size(eqns)
% 
% sols = double(struct2array(solve(eqns, [a,b])));
% P = [sols(1:3); sols(4:6)];

%===========================================
% M = [all_protos; r1; r2];
% J = M*all_protos';
% [Jsize, Jdim] = size(J);
% 
% % Overlapping between old and new prototypes
% R = Q * (1-eta/N);
% 
% a = sym('a', [1,4]);
% b = sym('b', [1,4]);
% syms eqns;
% eqns(1) = [];
% 
% U = [a; b];
% eq = U*J;
% for i = 1:2
%     for j = 1:2
%         eqns(end+1) = eq(i,j)==R(i,j);
%     end
% end
% 
% S = M*M';
% eq2 = U*S*U';
% for i = 1:2
%     for j = 1:2
%         eqns(end+1) = eq2(i,j)==Q(i,j);
%     end
% end
% 
% sols = double(struct2array(solve(eqns, [a,b])));
% 
% P = [sols(1:4); sols(5:8)];

% test if q equals Q

% syms a b c d e f
% eqns = [eqn1, eqn2, eqn3, eqn4, eqn5];
% vars = [a b c d e f];
% 
% S1 = solve(eqns, vars);
% sola = double(S1.a);
% solb = double(S1.b);
% solc = double(S1.c);
% sold = double(S1.d);
% sole = double(S1.e);
% solf = double(S1.f);

% if(isempty(sola) && isempty(solb) && isempty(solc) && isempty(sold) && isempty(sole) && isempty(solf))
%     proto1_new = proto1;
%     proto2_new = proto2;
% else
%     random = randsample(4,1);
%     a = real(sola(random, :));
%     b = real(solb(random, :));
%     c = real(solc(random, :));
%     d = real(sold(random, :));
%     e = real(sole(random, :));
%     f = real(solf(random, :));
% end
%     
    
end

