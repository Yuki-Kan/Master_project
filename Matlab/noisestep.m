 % given w1,w2:  constructs new vectors w1new, w2new with
 % exact overlaps as required (even for small n) 

 n=100;    % dimension
 eta= 2;   % noise strength
 f2= 2*eta/n-eta^2/n/n;  % second term could be neglected for large n
 
 w1=randn(1,n); w1=w1/norm(w1);   % "student 1 after training step"
 w2=randn(1,n); w2=w2/norm(w2);     % "student 2 after training step"
 
 % compute overlaps
 q11=dot(w1,w1);  
 q12=dot(w1,w2);     % q12 can be negative! 
 q22=dot(w2,w2); 

 % three random vectors
 n1 = null([w1;w2]);   % null-space orthogonal to w1 and w2
 % d1 = size(n1,2); 
 d1 = n-2; 
 rc = rand(d1,1);  
 % construct vector via random coefficients rc in null-space and normalize
 r3 = (n1*rc)';   
 r3 = r3/norm(r3)*sqrt(f2*abs(q12));
 r3q= dot(r3,r3); 
  
 n2 = null([w1;w2;r3]); % null-space orthogonal to w1,w2 and r3
 % d2 = size(n2,2); 
 d2 = n-3; 
 rc = rand(d2,1); 
 r1 = (n2*rc)'; 
 r1 = r1/norm(r1)*sqrt(f2*q11-r3q);
 
 n3 = null([w1;w2;r3;r1]); 
 % construct vector via random coefficients rc in null-space and normalize
 % d3 = size(n3,2); 
 d3 = n-4; 
 rc = rand(d3,1);
 r2 = (n3*rc)'; 
 r2 = r2/norm(r2)*sqrt(f2*q22-r3q); 
 
 % construct new student vectors
 w1new = w1*(1-eta/n) + r1 + sign(q12)*r3;  
 w2new = w2*(1-eta/n) + r2 +           r3; 

 % check required overlaps 
 q11new= dot(w1new,w1new);
 q12new= dot(w1new,w2new);
 q22new= dot(w2new,w2new);
 
 if(0)
    r11 = dot(w1new,w1)/q11;  % should be 1-eta/n
    r12 = dot(w1new,w2)/q12;  % should be 1-eta/n
    r21 = dot(w2new,w1)/q12;  % should be 1-eta/n
    r22 = dot(w2new,w2)/q22;  % should be 1-eta/n
 end
 
 