% Sets the threshold of just one neuron without recurrence based on the local field 

function A = set_threshold_duringtesting(A, neuron)

output = A.P.activation_function(A.L.local_field, A.P.thresholds, A.P.gain_factor); % column_vector
sparseness_output = sparseness(output);
sparseness_input = A.P.sparseness_input;

%%
incr_steps = 0;
previous_inc = 0;
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
    output = A.P.activation_function(A.L.local_field, A.P.thresholds, A.P.gain_factor); % column_vector
    sparseness_output = sparseness(output);
    
end

