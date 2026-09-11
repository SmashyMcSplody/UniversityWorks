numbers = input('Enter a vector of 20 numbers: ');

if length(numbers) ~= 20
    disp('Input must be a vector containing exactly 20 numbers.');
else
    total = 0;
    for i = 1:20
        total = total + numbers(i);
    end
    result = total / 20;
    
    % Automatically display the result
    fprintf('The mean of the 20 numbers is: %.4f\n', result);
end