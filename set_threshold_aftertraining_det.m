% The trainingset is used as an input
% Convergence is calculated for all the patterns at the same time
% Neurons are updated synchronously
% The threshold is updated after each iteration (recurrent cycles)
% Same threshold for all neurons

function A = set_threshold_aftertraining_det(A)
%%
sparseness_input = sparseness(A.D.trainingset);

output = A.D.trainingset;
%%

for r = 1 : A.P.timeout
    
    previous_output = output;
    weighted_sum = previous_output * A.W.state;
    sorted = sort(weighted_sum(:)); % increasing order
    index = numel(sorted) - round(sparseness_input * numel(sorted));
    value = sorted(index);
    
    i = 0;
    while sorted(index+i) == value
        upper_index = index+i;
        i = i + 1;
        if (index+i) > numel(sorted)
            break
        end
    end
    i = 0;
    while sorted(index+i) == value && index+1 > 0
        lower_index = index+i;
        i = i - 1;
        if (index+i) < 1
            break
        end
    end
    
    if lower_index > 1
        lower_thr = (sorted(lower_index) + sorted(lower_index-1))/2;
    else
        lower_thr = sorted(lower_index) - 1;
    end
    if upper_index < numel(sorted)
        upper_thr = (sorted(upper_index) + sorted(upper_index+1))/2;
    else
        upper_thr = sorted(upper_index) + 1;
    end
    
    lower_sparseness = sparseness(A.P.activation_function(weighted_sum, repmat(lower_thr, size(weighted_sum)), A.P.gain_factor));
    upper_sparseness = sparseness(A.P.activation_function(weighted_sum, repmat(upper_thr, size(weighted_sum)), A.P.gain_factor));
    
    if abs(lower_sparseness - sparseness_input) <= abs(upper_sparseness - sparseness_input)
        A.L.thresholds = zeros(1, A.P.nbof_neurons) + lower_thr;
    else
        A.L.thresholds = zeros(1, A.P.nbof_neurons) + upper_thr;
    end
    
    output = A.P.activation_function(weighted_sum, A.L.thresholds, A.P.gain_factor);
    diff = abs(output - previous_output);
    
    if sum(diff) <= A.P.convergence_threshold
        r
        break
    end
    
end
%%