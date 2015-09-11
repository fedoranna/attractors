function A = calculate_performance(A)

A.T.correctness = A.T.outputs == A.D.testingset_O;
A.T.scores = mean(A.T.correctness, 2);          % 0 to 1; proportion of correct neurons for each testing pattern; same as 1 - normalized Hamming distance
corr_matrix = corrcoef(A.T.outputs, A.D.testingset_O);
if isnan(corr_matrix(1,2)) % if either the output or the input consists of straight 0s or 1s, corr = NaN
    corr_matrix(1,2) = 0;
end

%%  Possible fitness measures

A.T.nbof_correct = sum(A.T.scores == 1);    % 0 to P.nbof_patterns; nb of perfectly correct testing patterns
A.T.nbof_90perc_correct = sum(A.T.scores > 0.9); % 0 to P.nbof_patterns

A.T.correlation = corr_matrix(1,2);         % -1 to 1
A.T.avg_score = mean(A.T.scores);           % 0 to 1; avg score on all testing patterns
A.T.propof_correct = A.T.nbof_correct / size(A.T.outputs, 1); % 0 to 1; proportion of perfectly recalled patterns

A.T.avg_score_perc = mean(A.T.scores)*100;  % 0 to 100; avg score percentage on all testing patterns
A.T.percof_correct = (A.T.nbof_correct / size(A.T.outputs, 1)) * 100; % 0 to 100; percentage of perfectly correct testing patterns
A.T.percof_90perc_correct = (A.T.nbof_90perc_correct / size(A.T.outputs, 1)) * 100; % 0 to 100; percentage of perfectly correct testing patterns

