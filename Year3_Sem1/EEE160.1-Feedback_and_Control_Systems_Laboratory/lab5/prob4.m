%% Elisha John D. Aton Problem #4
eqn = tf(1, [1 4 4]);

% Step response from MATLAB
[y_eqn, t] = step(eqn);
% Analytical solution
solved_eqn = 1/4 - (1/4)*exp(-2*t) - (1/2)*t.*exp(-2*t);

% Plotting
figure; hold on; grid on;
plot(t, y_eqn, 'b-', 'LineWidth', 2);
plot(t, solved_eqn, 'r--', 'LineWidth', 2);
title('Step Response: Analytical vs step()');
xlabel('Time (s)'); ylabel('y(t)');
legend('step()', 'Analytical');