%% Elisha John D. Aton Prob #2
tfunctionA = tf(1, [1 0.2 1]);
tfunctionB = tf([1 0], [1 0.2 1]);

figure;
impulse(tfunctionA);
title('Impulse Response Function A');
figure;
step(tfunctionB);
title('Step Response Function B');
