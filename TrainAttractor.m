function A = TrainAttractor(A, varargin)

ip = inputParser;
defaultWeightVisualizer = @NOP;
addRequired(ip, 'A');
addOptional(ip, 'weightVisualizer', defaultWeightVisualizer);
parse(ip, A, varargin{:});
A = ip.Results.A; 
weightVisualizer = ip.Results.weightVisualizer;

switch A.P.learning_rule
    case 'Hebbian1' % Rolls, 2012, p45
        inc = A.P.learning_rate * (A.D.trainingset'* A.D.trainingset);
        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state + inc;
        A.W.state(A.W.eliminated) = 0;
        
    case 'Hebbian2'
        a = A.P.activation_function(A.W.state * A.D.trainingset', A.P.threshold)'; % activation before learning for each pattern
        inc = a' * a;
        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state + A.P.learning_rate * inc;
        A.W.state(A.W.eliminated) = 0;
        
    case 'covariance1' % Rolls, 2012    
        a = mean(mean(A.D.trainingset)); % this is one number
        N = size(A.D.trainingset, 1);    
        inc = (1/(N*a*a)) * ((A.D.trainingset-a)' * (A.D.trainingset-a));
        
        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state + A.P.learning_rate * inc;       
        A.W.state(A.W.eliminated) = 0;
    
    case 'covariance2' % same as covariance1 but mean activity is calculated per neuron, and not per network
        a = mean(A.D.trainingset); % this is a row vector
        N = size(A.D.trainingset, 1);    
        arep = repmat(a,N,1);                               
        inc = (1./(N*(a'*a))) .* ((A.D.trainingset-arep)' * (A.D.trainingset-arep));
        % Problem: if there is a neuron which is never active, then there
        % will be Infs in the first part and 0s in the second part and
        % Inf*0 = NaN. The whole inc will be NaN!

        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state + A.P.learning_rate * inc;       
        A.W.state(A.W.eliminated) = 0;
        %weightVisualizer(A.W);
        
    otherwise 
        'Error: learning rule is unknown!'
end