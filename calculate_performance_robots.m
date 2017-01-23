function A = calculate_performance_robots(A)

%% Motor commands
% position is a vector of 8 values - each is a command for a motor
% values in "position" are [-50, 50] when unit=100; 
% they are calculated as the number of active neurons among the first 50 
% neurons minus the number of active neurons among the second 50 neurons

unit = numel(A.T.outputs) / 8;
A.T.position = NaN(1,8); 
for i = 1:8
    tol = unit*(i-1)+1;
    ig = unit*i;
    A.T.position(i) = sum(A.T.outputs(tol:tol+unit/2-1)==1) - sum(A.T.outputs(tol+unit/2:ig)==1);
end

%% Made up fitness function

normalized = sum(A.T.position)/(8*(unit/2)); % [-1, +1]
A.T.fitness_normalized = normalized;
A.T.fitness_maximize = 0.5 + 0.5*normalized;
A.T.fitness_minimize = 0.5 + (-0.5)*normalized;

