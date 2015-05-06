%% Very simple attractor network

clear all
addpath(genpath('C:\Matlab_functions\Attractor\'));

%% Parameters
nbof_training_patterns = 10;
nbof_testing_patterns = 3;
lengthof_patterns = 6;
sparseness = 0.5;
threshold = 9;
timeout = 100;
convergence_threshold = 0;
patternseed = 5; % 5:generates 13 unique patterns of length 6

% Patterns
rng(patternseed, 'twister');
patterns = double(rand(nbof_training_patterns+nbof_testing_patterns, lengthof_patterns) <= sparseness);
trainingset = patterns(1:nbof_training_patterns, :);
testingset = patterns(nbof_training_patterns+1 : end,:);

size(unique(patterns, 'rows'),1) == nbof_training_patterns + nbof_testing_patterns; % should be 1

% trainingset = [
%     1 1 0 1 1 0;
%     0 1 0 1 0 1];
% testingpattern = [1 1 0 0 1 0];

% Train and normalize
W = trainingset' * trainingset;
for i = 1:size(W,1) % delete self-loops
    W(i,i) = 0;
end
%W = W/max(max(W)); % normalize

% Test on trainingpatterns
outputs_for_trainingpatterns = NaN(nbof_training_patterns, lengthof_patterns);
for i = 1:nbof_training_patterns    
    testingpattern = trainingset(i,:);
    output = transferfn_step(testingpattern * W, threshold);  
    %output = testingpattern;
    for r = 1 : timeout
        previous_output = output;
        output = transferfn_step(previous_output * W, threshold);
        diff = abs(output - previous_output);
        if sum(diff) <= convergence_threshold
            break
        end
    end 
    outputs_for_trainingpatterns(i,:) = output;
end

% How many patterns could be recalled? 3; #2,#7 and #10
d_outputs_trainingpatterns = NaN(1, size(trainingset,1));
for i = 1:size(trainingset,1)
    d_outputs_trainingpatterns(i) = Hamming_distance(outputs_for_trainingpatterns(i,:), trainingset(i,:));
end
d_outputs_trainingpatterns
sum(d_outputs_trainingpatterns);

% How should we apply the input during testing? Directly or through weights?
% and during training?
% How do you set the threshold?

% Testing: before the transferfn, input*W = sum(W(active_inputs,:))

% The threshold is critical! If the first output is all zeros, then
% recurrence will produce all zeros too!
% Same goes for 1s
% What does recurrence do?

%% Test on new patterns

index_of_testing_pattern = 2;

testingpattern = patterns(index_of_testing_pattern, :);
O = NaN(0, lengthof_patterns);
output = transferfn_step(testingpattern * W, threshold);  
O(1,:) = output;
for r = 1 : timeout
    previous_output = output;
    output = transferfn_step(previous_output * W, threshold);
    O(1+r,:) = output;
    diff = abs(output - previous_output);
    if sum(diff) <= convergence_threshold
        break
    end
end 
O(r+2, :) = testingpattern;

% Does recurrence bring the output closer to the testingpattern? NO
d_O_testingpattern = NaN(1, size(O,1)-1);
for i = 1:size(O,1)-1
    d_O_testingpattern(i) = Hamming_distance(O(i,:), testingpattern);
end
plot(d_O_testingpattern)

% Is the output a member of the trainingset? NO
d_output_trainingset = NaN(1, size(trainingset,1));
for i = 1:size(trainingset,1)
    d_output_trainingset(i) = Hamming_distance(output, trainingset(i,:));
end
ismember(0, d_output_trainingset)

% Is the output for an unknown pattern the closest member of the trainingset?
[sorted, index] = sort(d_output_trainingset);
closest_trained_pattern = trainingset(index(1),:);
sum(closest_trained_pattern == output) == lengthof_patterns









































