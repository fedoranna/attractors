function A = TrainAttractor(A)

switch A.P.learning_rule
    case 'Hebbian1'
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
        
    case 'covariance' % Rolls, 2012    
        a = mean(mean(A.D.trainingset));
        N = A.P.nbof_patterns;    
        inc = (1/(N*a*a)) * ((A.D.trainingset-a)' * (A.D.trainingset-a));
        
        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state + A.P.learning_rate * inc;       
        A.W.state(A.W.eliminated) = 0;
    
    case 'covariance2' % same as covariance but mean activity is calculated per neuron, and not per network
        a = mean(A.D.trainingset);
        arep = repmat(a,A.P.nbof_patterns,1);        
        N = A.P.nbof_patterns;                
        inc = (1./(N*(a'*a))) * ((A.D.trainingset-arep)' * (A.D.trainingset-arep));

        A.W.state = A.W.state * A.P.forgetting_rate;
        A.W.state = A.W.state + A.P.learning_rate * inc;       
        A.W.state(A.W.eliminated) = 0;
        
    otherwise 
        'Error: learning rule is unknown!'
end