%% Elisha John D. Aton Problem #2

function [shadedArea, unshadedArea] = flowerArea(s)
    r = s / 2;
    squareArea = s^2;
    
    % Four semicircles equal two full circles:
    fourSemicirclesArea = 4 * (0.5 * pi * r^2); 
    
    % Overlapping regions form the 4 petals:
    shadedArea = fourSemicirclesArea - squareArea;
    unshadedArea = squareArea - shadedArea;

    fprintf('Shaded Area: %.4f\n', shadedArea);
    fprintf('Unshaded Area: %.4f\n', unshadedArea);
end