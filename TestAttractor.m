function A = TestAttractor(A)

A.T.scores = NaN(size(A.D.testingset_I, 1), 1);
A.T.outputs = NaN(size(A.D.testingset_I, 1), A.P.nbof_neurons);
for p = 1 : size(A.D.testingset_I, 1)         % patterns

    A.L.output = A.P.activation_function(A.W.state * A.D.testingset_I(p,:)', A.P.threshold);       
    for r = 1 : A.P.timeout
        previous_output = A.L.output;
        A.L.output = A.P.activation_function(A.W.state * previous_output, A.P.threshold);
        diff = abs(A.L.output - previous_output);
        if sum(diff) <= A.P.convergence_threshold
            break
        end
    end 
    A.T.outputs(p,:) = A.L.output;
    
end

% if there is a threshold for active and inactive it comes here: A.L.output = 

A.T.correctness = A.T.outputs == A.D.testingset_O;

% Possible fitness measures
A.T.scores = mean(A.T.correctness, 2);          % 0 to 1; proportion of correct neurons for each testing pattern
A.T.avg_score = mean(A.T.scores);           % 0 to 1; avg score on all testing patterns
A.T.avg_score_perc = mean(A.T.scores)*100;  % 0 to 100; avg score percentage on all testing patterns
A.T.nbof_correct = sum(A.T.scores == 1);    % 0 to P.nbof_patterns; nb of perfectly correct testing patterns
A.T.nbof_90perc_correct = sum(A.T.scores > 0.9);
A.T.percof_correct = (A.T.nbof_correct / A.P.nbof_patterns) * 100; % 0 to 100; percentage of perfectly correct testing patterns
