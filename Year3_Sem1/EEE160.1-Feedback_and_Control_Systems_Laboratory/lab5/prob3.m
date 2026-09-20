%% Elisha John D. Aton Problem #3
tf_denominator = [1 3 15];
z_values = [3 6 12];

% Unit step
figure; hold on; grid on;
for z = z_values
    tf_numerator = (15/z)*[a1 z];
    sys = tf(tf_numerator, tf_denominator);
    [y, t] = step(sys);
    plot(t, y, 'LineWidth', 1.5);
end
title('Unit Step Response');
legend('z = 3', 'z = 6', 'z = 12');

% Unit impulse
figure; hold on; grid on;
for z = z_values
    tf_numerator = (15/z)*[1 z];
    sys = tf(tf_numerator, tf_denominator);
    [y, t] = impulse(sys);
    plot(t, y, 'LineWidth', 1.5);
end
title('Unit Impulse Response');
legend('z = 3', 'z = 6', 'z = 12');