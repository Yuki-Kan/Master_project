function [B, J] = weight_init(Q, R, T, K, M, N)
%This function uses a generalized Gram-Schmidt procedure to initialize the
%weight vectors such that they satisfy the given order parameters.
    fprintf('Initializing weight vectors...\n');

    %Initialize M + K random vectors
    B_r = zeros(N, M);
    J_r = zeros(N, K);
    
    for n=1:M
       B_r(:,n) = randn(N,1);
       B_r(:,n) = B_r(:,n)/norm(B_r(:,n));
    end

    for i=1:K
       J_r(:,i) = randn(N,1);
       J_r(:,i) = J_r(:,i)/norm(J_r(:,i));
    end
    
    B = zeros(N,M);
    %Initialize the first vector as a random vector with magnitude T_{11}
    B(:,1) = sqrt(T(1,1)) * B_r(:,1);
    for n=2:M
        %Initialization of n-th teacher: Bn = c1*B1 + c2*B2 + ... + cn*Bn_r
        c = sym('c', [n,1]);
        Bn = 0;
        for i=1:n-1
           Bn = Bn + c(i) * B(:,i); 
        end
        %add random vector
        Bn = Bn + c(n) * B_r(:,n);

        %Create the equations B1.Bn=T(1,n), B2.Bn=T(2,n), Bn.Bn=T(n,n) and
        %solve for the coefficients numerically.
        syms eqns;
        eqns(1) = [];
        for i=1:n-1
            %Create the equation Bi.Bn=T(i,n) where i < n
            eq = 0;
            for j=1:n-1
               eq = eq + c(j) * dot(B(:,j), B(:,i)); 
            end
            %random term
            eq = eq + c(n) * dot(B_r(:,n), B(:,i));
            eq = eq - T(i,n);
            eqns(end+1) = eq;
        end
        %Add the quadratic equation Bn.Bn=T(n,n)
        eq = 0; %n*(n+1)/2 terms
        for i=1:n-1
           eq = eq + c(i)^2 * dot(B(:,i), B(:,i));
        end
        eq = eq + c(n)^2 * dot(B_r(:,n), B_r(:,n));
        for i=1:n-1
            for j=1:i-1
                eq = eq + 2 * c(i) * c(j) * dot(B(:,i), B(:,j));
            end
        end
        for j=1:n-1
           eq = eq + 2 * c(n) * c(j) * dot(B_r(:,n), B(:,j)); 
        end
        eq = eq - T(n,n);
        eqns(end+1) = eq;
        %Solve the system of n-1 linear + 1 quadratic equation(s) numerically
        %for the c's
        sols = struct2array(solve(eqns, c)); %First row is first solution for c

        B(:,n) = subs(Bn, c, sols(1,:)');

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
    
    %Test teacher basis initialization
    T_init = B' * B;
    Q_init = J' * J;
    R_init = J' * B;
    
    %Verify that the initialization is reasonably exact compared to the
    %given order parameters
    maxDiff = max(abs([T_init(:); Q_init(:); R_init(:)] - [T(:); Q(:); R(:)]));
    if all(maxDiff < 10^-6)
        fprintf('Weight vectors initialized to O(%.4e) deviation!\n', ...
            maxDiff);
    else
        warning('Weight vectors deviate O(%.4e) from required order params\n', ...
            maxDiff);
    end
end