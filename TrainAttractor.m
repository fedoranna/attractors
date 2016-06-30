function A = TrainAttractor(A, varargin)

%%
switch A.P.learning_rule
    case 'Hebbian1' % Rolls, 2012, p45
        inc = A.P.learning_rate * (A.D.trainingset'* A.D.trainingset);
        A.W.state = A.W.state * (1-A.P.forgetting_rate);
        A.W.state = A.W.state + inc;
        A.W.state = A.W.state .* A.W.masking_matrix;
        
    case 'Hebbian2'
        a = A.P.activation_function(A.W.state * A.D.trainingset', A.P.threshold)'; % activation before learning for each pattern
        inc = A.P.learning_rate * (a' * a);
        A.W.state = A.W.state * (1-A.P.forgetting_rate);
        A.W.state = A.W.state +  inc;
        A.W.state = A.W.state .* A.W.masking_matrix;
        
    case 'covariance1' % Rolls, 2012; sparseness is calculated for the whole trainingset
        a = sparseness(A.D.trainingset); % this is one scalar
        N = size(A.D.trainingset, 1); % number of patterns
        
        if a > 0
            inc = (1/(N*a*a)) * ((A.D.trainingset-a)' * (A.D.trainingset-a));
        else
            inc = zeros(size(A.W.state));
        end
        
        A.W.state = A.W.state * (1-A.P.forgetting_rate);
        A.W.state = A.W.state + A.P.learning_rate * inc;
        A.W.state = A.W.state .* A.W.masking_matrix;
        
    case 'covariance2' % sparseness is calculated per neuron
        a = mean(A.D.trainingset, 1); % this is a row vector
        N = size(A.D.trainingset, 1); % number of patterns
        arep = repmat(a,N,1);
        
        if N>1
            inc = (1./(N*(a'*a))) .* ((A.D.trainingset-arep)' * (A.D.trainingset-arep));
        else % Problem 1: if there is only one pattern, trainingset-arep = 0s, so the whole inc would be 0
            inc = (1./(N*(a'*a))) .* (A.D.trainingset' * A.D.trainingset);
        end
        
        % Problem 2: if there is a neuron which is never active, then there will be 0s in a'*a
        for i = 1:numel(inc)
            if isnan(inc(i)) || isinf(inc(i))
                inc(i) = 0;
            end
        end
        
        A.W.state = A.W.state * (1-A.P.forgetting_rate);
        A.W.state = A.W.state + A.P.learning_rate * inc;
        A.W.state = A.W.state .* A.W.masking_matrix;
        
    case 'Storkey' % based on Storkey, 2015
        
        A.W.state = A.W.state * (1-A.P.forgetting_rate);
        
        h = A.D.trainingset*A.W.state;
        inc = 1/A.P.nbof_neurons * (A.D.trainingset'*A.D.trainingset - A.D.trainingset'*h - h'*A.D.trainingset);
        
        A.W.state = A.W.state + A.P.learning_rate * inc;
        A.W.state = A.W.state .* A.W.masking_matrix;
        
    case 'Storkey_bypattern'
        
        for p = 1:size(A.D.trainingset,1)
            A.W.state = A.W.state * (1-A.P.forgetting_rate);
            pattern = A.D.trainingset(p,:);
            
            h = pattern*A.W.state;
            inc = 1/A.P.nbof_neurons * (pattern'*pattern - pattern'*h - h'*pattern);
            
            A.W.state = A.W.state + A.P.learning_rate * inc;
            A.W.state = A.W.state .* A.W.masking_matrix;
        end
        
    otherwise
        'Error: learning rule is unknown!'
end

%% Normalize

if A.P.normalize == 1
    A.W.state = A.W.state / max(A.W.state(:));
end

%% Set threshold

if A.P.autothreshold_aftertraining
    A = A.P.threshold_algorithm(A);
end

























