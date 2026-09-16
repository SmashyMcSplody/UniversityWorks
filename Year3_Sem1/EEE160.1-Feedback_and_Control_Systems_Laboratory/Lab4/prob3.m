%% Elisha John D. Aton Problem #3

syms s t

eqn = (6/s)-(1/(s-8))+(4/(s-3));
sol = ilaplace(eqn, s, t);
disp(sol)