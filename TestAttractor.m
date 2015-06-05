function A = TestAttractor(A)

A.T.outputs = NaN(size(A.D.testingset_I, 1), A.P.nbof_neurons);

if A.P.synchronous_update
    
    for p = 1 : size(A.D.testingset_I, 1)         % patterns
        
        A.L.output = A.D.testingset_I(p,:);
        for r = 1 : A.P.timeout
            previous_output = A.L.output;
            A.L.output = A.P.activation_function(previous_output * A.W.state, A.P.threshold, A.P.gain_factor);
            diff = abs(A.L.output - previous_output);
            if sum(diff) <= A.P.convergence_threshold
                break
            end
            if A.P.autothreshold_duringtesting
                A = set_threshold_duringtesting(A, neuron);
            end
        end
        A.T.outputs(p,:) = A.L.output;
        
    end
    
else % asynchronous update
    
    %a = A.P.sparseness_input;
    a = sparseness(A.D.testingset_I);
    order = randperm(A.P.nbof_neurons, A.P.nbof_neurons);
    A.L.outputs = A.D.testingset_I; % all patterns, all neurons
    
    for n = 1:numel(order)
        neuron = order(n); % the neuron to be updated
        
        for r = 1 : A.P.timeout
            previous_output = A.L.outputs(:, neuron);
            
            internal_field = A.L.outputs * A.W.state(:, neuron); % column vector for the internal activation of 1 neuron to all patterns
            s = A.P.field_ratio;
            %           s = (A.P.field_ratio * internal_field) ./ A.D.testingset_I(:,neuron); % column vector
            %             % There could be NaNs if 0/0, (or Inf if x/0, but it seems it does not work without Infs)
            %             for i = 1:numel(s)
            %                 if isnan(s(i))
            %                     s(i) = 0;
            %                 end
            %             end
            external_field = A.D.testingset_I(:,neuron) .* (s/a);
            A.L.local_field = internal_field + external_field; % column vector for the current neuron and each pattern
            
            if A.P.autothreshold_duringtesting
                A = set_threshold_duringtesting(A, neuron);
            end
            
            activation = A.P.activation_function(A.L.local_field, A.L.thresholds(neuron), A.P.gain_factor); % column_vector
            A.L.outputs(:,neuron) = activation;
            
            diff = abs(A.L.outputs(:, neuron) - previous_output);
            if sum(diff) <= A.P.convergence_threshold
                break
            end
        end
%         if A.P.autothreshold_duringtesting
%             A = set_threshold_duringtesting(A, neuron);
%         end
    end
    A.T.outputs = A.L.outputs;
    
end

% Tolerance threshold
if A.P.tolerance > 0
    A.T.outputs = binarize(A.T.outputs, A.P.tolerance, A.P.inactive_input);
end

A.T.correctness = A.T.outputs == A.D.testingset_O;
A.T.scores = mean(A.T.correctness, 2);          % 0 to 1; proportion of correct neurons for each testing pattern
corr_matrix = corrcoef(A.T.outputs, A.D.testingset_O);
if isnan(corr_matrix(1,2)) % if either the output or the input consists of straight 0s or 1s, corr = NaN
    corr_matrix(1,2) = A.T.scores;
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



