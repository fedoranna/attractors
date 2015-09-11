function A = TestAttractor(A)

A.T.outputs = NaN(size(A.D.testingset_I));

if A.P.synchronous_update
    
    for p = 1 : size(A.D.testingset_I, 1)         % patterns
        
        A.L.state = A.D.testingset_I(p,:);
        for r = 1 : A.P.timeout
            previous_output = A.L.state;
            A.L.state = A.P.activation_function(previous_output * A.W.state, A.L.thresholds, A.P.gain_factor);
            diff = abs(A.L.state - previous_output);
            if sum(diff) <= A.P.convergence_threshold
                break
            end
%             if A.P.autothreshold_duringtesting
%                 A = set_threshold_duringtesting(A, neuron);
%             end
        end
        A.T.outputs(p,:) = A.L.state;
        
    end
    
else % asynchronous update
    
    order = randperm(A.P.nbof_neurons, A.P.nbof_neurons);
    A.L.state = A.D.testingset_I; % all patterns, all neurons
    
    for n = 1:numel(order)
        neuron = order(n); % the neuron to be updated
        
        for r = 1 : A.P.timeout
            previous_output = A.L.state(:, neuron);
            
            internal_field = A.L.state * A.W.state(:, neuron); % column vector for the internal activation of 1 neuron to all patterns
            s = A.P.field_ratio;
            %           s = (A.P.field_ratio * internal_field) ./ A.D.testingset_I(:,neuron); % column vector
            %             % There could be NaNs if 0/0, (or Inf if x/0, but it seems it does not work without Infs)
            %             for i = 1:numel(s)
            %                 if isnan(s(i))
            %                     s(i) = 0;
            %                 end
            %             end
            % nanmean(s)?
            external_field = A.D.testingset_I(:,neuron) .* (s/sparseness(A.D.testingset_I(:,neuron)));
            A.L.local_field = internal_field + external_field; % column vector for the current neuron and each pattern
            
            if A.P.autothreshold_duringtesting
                A = set_threshold_duringtesting(A, neuron);
            end
            
            activation = A.P.activation_function(A.L.local_field, repmat(A.L.thresholds(neuron), size(A.L.local_field)), A.P.gain_factor); % column_vector
            A.L.state(:,neuron) = activation;
            
            diff = abs(A.L.state(:, neuron) - previous_output);
            if sum(diff) <= A.P.convergence_threshold
                break
            end
        end
%         if A.P.autothreshold_duringtesting
%             A = set_threshold_duringtesting(A, neuron);
%         end
    end
    A.T.outputs = A.L.state;
    
end

% Tolerance threshold
if A.P.tolerance > 0
    A.T.outputs = binarize(A.T.outputs, A.P.tolerance, A.P.inactive_input);
end

A = calculate_performance(A);


