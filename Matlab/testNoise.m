r = rand(1, 3);
r = r/norm(r);

w1 = [1 2 3];
w1 = [1 2 3]./norm(w1);

w1*w1'


syms a r 
eqn1 = w1*w1' + a * r * w1' == 1-0.5/4;
eqn2 = (w1+a*r)*(w1+a*r)' == 1;
eqns = [eqn1, eqn2];
vars = [a r];
S1 = solve(eqns, vars);


w1_new = w1 + S1a*r;


w1_new*w1_new'
w1_new * w1'


q = w1_new' .* w1_new;
sum = q(1,1)+q(2,2)+q(3,3);

Q = w1'.* w1;
Sum = Q(1,1)+Q(2,2)+Q(3,3);
w1* w1'


