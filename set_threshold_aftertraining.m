function A = set_threshold_aftertraining(A)

outputs = NaN(size(A.D.testingset_I, 1), A.P.nbof_neurons);
for p = 1 : size(A.D.testingset_I, 1)         % synchronous update per patterns
    
    output = A.P.activation_function(A.D.testingset_I(p,:) * A.W.state, A.L.thresholds, A.P.gain_factor);
    for r = 1 : A.P.timeout
        previous_output = output;
        output = A.P.activation_function(previous_output * A.W.state, A.L.thresholds, A.P.gain_factor);
        diff = abs(output - previous_output);
        if sum(diff) <= A.P.convergence_threshold
            break
        end
    end
    outputs(p,:) = output;
    
end

sparseness_output = sparseness(outputs);
sparseness_input = sparseness(A.D.trainingset);

incr_steps = 0;
previous_inc=0;
while abs(sparseness_input - sparseness_output) > A.P.sparseness_difference
    
    % Timeout
    incr_steps = incr_steps + 1;
    if incr_steps > A.P.threshold_setting_timeout
        break
    end
    
    % Change threshold
    if sparseness_output < sparseness_input
        inc = - A.P.threshold_incr;
    else
        inc = + A.P.threshold_incr;
    end
    A.L.thresholds = A.L.thresholds + inc;
    
    % Prevent oscillations
    if inc == -previous_inc
        if abs(sparseness_input - previous_sparseness) < abs(sparseness_input - sparseness_output)
            A.L.thresholds = A.L.thresholds + previous_inc;
        end
        break
    else        
        previous_inc = inc;
        previous_sparseness = sparseness_output;
    end
    
    % Recalculate outputs
    outputs = NaN(size(A.D.testingset_I, 1), A.P.nbof_neurons);
    for p = 1 : size(A.D.testingset_I, 1)         % patterns
        
        output = A.P.activation_function(A.D.testingset_I(p,:) * A.W.state, A.L.thresholds, A.P.gain_factor);
        for r = 1 : A.P.timeout
            previous_output = output;
            output = A.P.activation_function(previous_output * A.W.state, A.L.thresholds, A.P.gain_factor);
            diff = abs(output - previous_output);
            if sum(diff) <= A.P.convergence_threshold
                break
            end
        end
        outputs(p,:) = output;
        
    end
    sparseness_output = sparseness(outputs);
    
end



