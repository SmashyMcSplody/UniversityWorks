%% Elisha John D. Aton Problem #1B

syms y(x)

eqn1B = diff(y, x) == 7*y^2 * x^3;
cond = y(2) == 3;
sol1B = simplify(dsolve(eqn1B, cond))