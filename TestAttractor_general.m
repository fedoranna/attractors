% Saves output, does not calcualte fintess!

function A = TestAttractor_general(A)

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
        end
        A.T.outputs(p,:) = A.L.state;
        
    end
    
else % asynchronous update
    
    for p = 1 : size(A.D.testingset_I, 1)         % patterns
        
        if A.P.update_each == 1
            order = randperm(A.P.nbof_neurons, A.P.nbof_neurons); % each neuron is updated exactly once
        else
            order = randi(A.P.nbof_neurons, 1, A.P.nbof_neurons); % choose neurons to update with replacement
        end
        updated = unique(order);

        A.L.state(updated) = A.D.testingset_I(p,updated);
        for r = 1 : A.P.timeout
            previous_output = A.L.state;
            for n = 1:numel(order)
                neuron = order(n); % the neuron to be updated
                A.L.state(neuron) = A.P.activation_function(previous_output * A.W.state(:, neuron), A.L.thresholds(neuron), A.P.gain_factor);
            end
            diff = abs(A.L.state - previous_output);
            if sum(diff) <= A.P.convergence_threshold
                break
            end
        end      
    
        A.T.outputs(p,:) = A.L.state;
    end
end

% Tolerance threshold
if A.P.tolerance > 0
    A.T.outputs = binarize(A.T.outputs, A.P.tolerance, A.P.inactive_input);
end


%r

