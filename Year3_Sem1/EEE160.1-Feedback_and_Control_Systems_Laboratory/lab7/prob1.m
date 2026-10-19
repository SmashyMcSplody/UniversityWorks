%% Elisha John D. Aton Prob #1
syms s F X1 X2 X3

M1=1; M2=2; M3=1;
K1=1; K2=1;
fv1=1; fv2=1; fv3=1;

eq1 = (M1*s^2 + (fv2+fv3)*s + K2)*X1 - fv2*s*X2 - (fv3*s + K2)*X3 == 0;
eq2 = -fv2*s*X1 + (M2*s^2 + (fv1+fv2)*s + K1)*X2 - (fv1*s + K1)*X3 == 0;
eq3 = -(fv3*s + K2)*X1 - (fv1*s + K1) *X2 + (M3*s^2 + (fv1 + fv3)*s + (K1 + K2))*X3 == F;

sol = solve([eq1 eq2 eq3], [X1 X2 X3]);
G1  = simplify(sol.X1 / F)

[n, d] = numden(G1);
G1_tf  = tf(sym2poly(expand(n)), sym2poly(expand(d)))