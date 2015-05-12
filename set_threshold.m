function A = set_threshold(A)

sparseness_input = sparseness(A.D.testingset_I);

outputs = NaN(size(A.D.testingset_I, 1), A.P.nbof_neurons);
for p = 1 : size(A.D.testingset_I, 1)         % patterns
    
    output = A.P.activation_function(A.D.testingset_I(p,:) * A.W.state, A.P.threshold);
    for r = 1 : A.P.timeout
        previous_output = output;
        output = A.P.activation_function(previous_output * A.W.state, A.P.threshold);
        diff = abs(output - previous_output);
        if sum(diff) <= A.P.convergence_threshold
            break
        end
    end
    outputs(p,:) = output;
    
end
sparseness_output = sparseness(output);

%%
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
    
    if inc == -previous_inc
        break
    else
        A.P.threshold = A.P.threshold + inc;
        previous_inc = inc;
    end
    
    % Recalculate outputs
    outputs = NaN(size(A.D.testingset_I, 1), A.P.nbof_neurons);
    for p = 1 : size(A.D.testingset_I, 1)         % patterns
        
        output = A.P.activation_function(A.D.testingset_I(p,:) * A.W.state, A.P.threshold);
        for r = 1 : A.P.timeout
            previous_output = output;
            output = A.P.activation_function(previous_output * A.W.state, A.P.threshold);
            diff = abs(output - previous_output);
            if sum(diff) <= A.P.convergence_threshold
                break
            end
        end
        outputs(p,:) = output;
        
    end
    sparseness_output = sparseness(output);
    
end

