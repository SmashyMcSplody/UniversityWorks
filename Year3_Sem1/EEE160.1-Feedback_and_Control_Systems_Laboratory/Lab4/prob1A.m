%% Elisha John D. Aton Problem #1A

syms y(x)

eqn1A = diff(y, x, 2) + 4*diff(y, x) - 10*y == exp(x);
sol1A = simplify(dsolve(eqn1A))

