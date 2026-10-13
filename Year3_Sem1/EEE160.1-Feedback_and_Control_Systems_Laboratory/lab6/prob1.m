%% Elisha John D. Aton Problem #1
syms I1 I2 I3 I4 Vi s

A = [ 2*s    -s       0       -s;
     -s      s+(1/s)   -1/s     0;
      0     -1/s      (2/s)+1  -1;
     -s      0       -1       2*s+1 ];
B = [I1; I2; I3; I4];
C = [Vi; 0; 0; 0]; 

X = A\C;

TF_I1 = simplify(X(1)/Vi);
TF_I2 = simplify(X(2)/Vi);
TF_I3 = simplify(X(3)/Vi);
TF_I4 = simplify(X(4)/Vi);

Vo = X(3) * (1/s);
TF_Vo = simplify(Vo/Vi);

pretty(TF_I1); 
pretty(TF_I2); 
pretty(TF_I3); 
pretty(TF_I4); 
pretty(TF_Vo);