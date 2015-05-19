function A = TrainAttractor(A, varargin)

ip = inputParser;
defaultWeightVisualizer = @NOP;
addRequired(ip, 'A');
addOptional(ip, 'weightVisualizer', defaultWeightVisualizer);
parse(ip, A, varargin{:});
A = ip.Results.A; 
weightVisualizer = ip.Results.weightVisualizer;

%%
switch A.P.learning_rule
    case 'Hebbian1' % Rolls, 2012, p45
        inc = A.P.learning_rate * (A.D.trainingset'* A.D.trainingset);
        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state + inc;
        A.W.state(A.W.eliminated) = 0;
        
    case 'Hebbian2'
        a = A.P.activation_function(A.W.state * A.D.trainingset', A.P.threshold)'; % activation before learning for each pattern
        inc = A.P.learning_rate * (a' * a);
        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state +  inc;
        A.W.state(A.W.eliminated) = 0;
        
    case 'covariance1' % Rolls, 2012    
        %a = mean(mean(A.D.trainingset)); % this is one number
        a = sparseness(A.D.trainingset);
        N = size(A.D.trainingset, 1);    
        inc = (1/(N*a*a)) * ((A.D.trainingset-a)' * (A.D.trainingset-a));
        
        % Problem 1: if there is a neuron which is never active, then there
        % will be Infs in the first part and 0s in the second part and
        % Inf*0 = NaN. The whole inc will be NaN!
        for i = 1:numel(inc)
            if isnan(inc(i))
                inc(i) = 0;
            end
        end
        
        % Problem 2: if there is only one pattern, trainingset-arep = 0s,
        % so the whole inc will be 0s
        if N == 1
            inc = A.D.trainingset' * A.D.trainingset;
        end
        
        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state + A.P.learning_rate * inc;       
        A.W.state(A.W.eliminated) = 0;
    
    case 'covariance2' % same as covariance1 but mean activity is calculated per neuron, and not per network
        a = mean(A.D.trainingset, 1); % this is a row vector
        %a = sparseness(A.D.trainingset);
        N = size(A.D.trainingset, 1);    
        arep = repmat(a,N,1);                               
        inc = (1./(N*(a'*a))) .* ((A.D.trainingset-arep)' * (A.D.trainingset-arep));
        
        % Problem 1: if there is a neuron which is never active, then there
        % will be 1/0=Infs in the first part and 0s in the second part and
        % Inf*0 = NaN.
        for i = 1:numel(inc)
            if isnan(inc(i))
                inc(i) = 0;
            end
        end
        
        % Problem 2: if there is only one pattern, trainingset-arep = 0s,
        % so the whole inc will be 0s; the rule below reduces the training
        % to the simplest Hebbian rule (it is not a covariance rule
        % anymore)
        if N == 1
            inc = (1./(N*(a'*a))) .* A.D.trainingset' * A.D.trainingset;
        end

        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state + A.P.learning_rate * inc;       
        A.W.state(A.W.eliminated) = 0;
        %weightVisualizer(A.W);
        
    otherwise 
        'Error: learning rule is unknown!'
end

if A.P.autothreshold_aftertraining
    A = set_threshold_aftertraining(A);
end

























