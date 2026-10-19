%% Elisha John D. Aton Problem #2
syms s T Th1 Th2

J1=5; J2=3;
D1=8;  D2=1;        
K1=9; K2=3;         

eq1 = (J1*s^2 + (D1+D2)*s + (K1+K2))*Th1 - (D2*s + K2)*Th2 == T;
eq2 = -(D2*s + K2)*Th1 + (J2*s^2 + D2*s  + K2)*Th2 == 0;

sol = solve([eq1 eq2], [Th1 Th2]);
G2  = simplify(sol.Th1 / T)

[n, d] = numden(G2);
G2_tf = tf(sym2poly(expand(n)), sym2poly(expand(d)))
