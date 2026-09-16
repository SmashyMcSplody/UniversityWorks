%% Elisha John D. Aton Problem #2

syms t s

eqn = t*exp(-5*t);
sol = laplace(eqn, t, s);
disp(sol);