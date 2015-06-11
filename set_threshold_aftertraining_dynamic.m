function A = set_threshold_aftertraining_dynamic(A)

% Calculate output synchronously until timeout

outputs = NaN(size(A.D.testingset_I));
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

% Initial sparseness difference
sparseness_output = sparseness(outputs);
sparseness_input = sparseness(A.D.trainingset);
error = sparseness_output - sparseness_input;
prev_error = error;

prev_step_size = A.P.threshold_incr;
iter_count = 0;

% errors = [];
% steps = [];
% thresholds = [];

% Changing the threshold
while abs(error) > A.P.sparseness_difference && iter_count < A.P.threshold_setting_timeout
    iter_count = iter_count + 1;
    
    % Change threshold
    step_direction = sign(error);
    step_size = prev_step_size * pow2(-0.5 + sign(error)*sign(prev_error));         % multiply step size by 2^-1.5 if we jumped over the target, or by factor of 2^0.5 if we're still far away
    A.L.thresholds = A.L.thresholds + step_size * step_direction;
    prev_step_size = step_size;
    
    % Prevent oscillations
%     if abs(error) > abs(prev_error) && sign(error) == sign(prev_error)*(-1)
%         break
%     end
    
    % Recalculate output and error
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
    prev_error = error;
    error = sparseness_output - sparseness_input;
    
%     errors = [errors, error];
%     steps = [steps, step_size*step_direction];
%     thresholds = [thresholds, A.L.thresholds(1)];
end

%%
% hold all
% plot(abs(errors))
% plot(steps)
% plot(thresholds)
% legend('Error', 'Increment', 'Threshold')
%%
% n = 10;
% x = 1:n;
% y = NaN(size(x));
% y(1) = 0.1; % starting step size
% 
% for i = 2:n
%     y(i) = y(i-1) * pow2(-0.5 + 1*1); % step size
% end
% 
% plot(y)















