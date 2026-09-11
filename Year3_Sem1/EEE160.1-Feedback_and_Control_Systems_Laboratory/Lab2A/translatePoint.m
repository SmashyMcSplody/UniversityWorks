%% Elisha John D. Aton Problem #1

function [xp, yp] = translatePoint(x, y, dx, dy)
    xp = x + dx;
    yp = y + dy;
    fprintf('Translated Point: (%d, %d)\n', xp, yp);
end