function [J] = Noise_Solver(Q, R, B, K, M, N)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

J_r = zeros(N, K);

for i=1:K
   J_r(:,i) = randn(N,1);
   J_r(:,i) = J_r(:,i)/norm(J_r(:,i));
end

J = zeros(N,K);
    %Initialize the students
    for i=1:K
        %Initialization of the i-th student:
        %Ji = c1*B1 + c2*B2 + ... + cM*BM + c_{M+1}*J1 + ... + c_{M+i}*J_r(:,i)
        c = sym('c', [M+i,1]); 
        Ji = 0;
        for j=1:M
            Ji = Ji + c(j) * B(:,j);
        end
        %Combinations with previously initialized students J
        for j=1:i-1
            Ji = Ji + c(M+j) * J(:,j);
        end
        Ji = Ji + c(end) * J_r(:,i);

        %Formulate the equations Ji.B1=R(i,1), ... , Ji.B_M=R(i,m)
        syms eqns;
        eqns(1) = [];
        for n=1:M
           %Formulate Ji.Bn=R(i,1)
           eq = 0;
           for j=1:M
               eq = eq + c(j) * dot(B(:,j), B(:,n));
           end
           for j=1:i-1
               eq = eq + c(M+j) * dot(J(:,j), B(:,n));
           end
           %add random component
           eq = eq + c(end) * dot(J_r(:,i), B(:,n));
           eq = eq - R(i,n);
           eqns(end+1) = eq;
        end

        %Formulate the equations Jk.Ji=Q(k,i) | k<i
        for k=1:i-1
           %Formulate equation Jk.Ji
           eq = 0;
           for j=1:M
               eq = eq + c(j) * dot(B(:,j), J(:,k));
           end
           for j=1:i-1
               eq = eq + c(M+j) * dot(J(:,j), J(:,k));
           end
           %add random component
           eq = eq + c(end) * dot(J_r(:,i), J(:,k));
           eq = eq - Q(k,i);
           eqns(end+1) = eq;
        end

        %Formulate the quadratic equation Ji.Ji=Q(i,i)
        eq = 0;
        for j=1:M
            eq = eq + c(j)^2 * dot(B(:,j), B(:,j));
        end

        for j=1:i-1
            eq = eq + c(M+j)^2 * dot(J(:,j), J(:,j));
        end

        eq = eq + c(end)^2 * dot(J_r(:,i), J_r(:,i));

        for j=1:M+i
           for k=1:j-1
               if j <= M
                   vec1 = B(:,j);
               elseif j > M && j < M+i
                   vec1 = J(:,j-M);
               else %j==M+i
                   vec1 = J_r(:,j-M);
               end

               if k <= M
                   vec2 = B(:,k);
               else %k > M && k < M+i
                   vec2 = J(:,k-M);
               end

               eq = eq + 2 * c(j) * c(k) * dot(vec1, vec2);
           end
        end

        eq = eq - Q(i,i);
        eqns(end+1) = eq;

        sols = struct2array(solve(eqns, c)); %First row is first solution for c
        J(:,i) = subs(Ji, c, sols(1,:)');
    end

end

