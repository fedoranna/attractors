function A = calculate_performance_robots(A)

%% Motor commands

unit = numel(A.T.outputs) / 8;
motors = NaN(1,8); % motors is a vector of 8 values - each is a command for a motor
for i = 1:8
    tol = unit*(i-1)+1;
    ig = unit*i;
    motors(i) = sum(A.T.outputs(tol:tol+unit/2-1)==1) - sum(A.T.outputs(tol+unit/2:ig)==1);
end

%% Made up fitness function
% values in "motors" are [-50, 50]

normalized = sum(motors)/(8*(unit/2)); % [-1, +1]

A.T.fitness_robots = normalized;
A.T.fitness_maximalize = 0.5 + 0.5*normalized;
A.T.fitness_minimalize = 0.5 + (-0.5)*normalized;

