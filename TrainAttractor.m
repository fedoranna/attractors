function A = TrainAttractor(A)

switch A.P.learning_rule
    case 'Hebbian1'
        A.W.state = A.W.state + A.P.learning_rate * (A.D.trainingset'* A.D.trainingset);
        A.W.state(A.W.eliminated) = 0;
    case 'Hebbian2'
        a = A.P.activation_function(A.W.state * A.D.trainingset', A.P.threshold)'; % activation before learning for each pattern
        A.W.state = A.W.state + A.P.learning_rate * (a' * a);
        A.W.state(A.W.eliminated) = 0;
    case 'covariance' % Rolls, 2012    
        a = mean(mean(A.D.trainingset));
        N = A.P.nbof_patterns;    

    %     inc = zeros(A.P.nbof_neurons, A.P.nbof_neurons);   
    %     for i = 1:A.P.nbof_neurons
    %         for j = 1:A.P.nbof_neurons
    %             for k = 1:A.P.nbof_patterns
    %                 inc(i,j) = inc(i,j) + (A.D.trainingset(k,i)-a) * (A.D.trainingset(k,j)-a);
    %             end
    %         end
    %     end

        inc = (1/(N*a*a)) * ((A.D.trainingset-a)' * (A.D.trainingset-a));

        A.W.state = A.W.state / A.P.forgetting_rate;
        A.W.state = A.W.state + A.P.learning_rate * inc;       
        A.W.state(A.W.eliminated) = 0;

        % Setting the threshold
    %     outputs = NaN(size(A.D.testingset, 1), A.P.nbof_neurons);
    %     for p = 1 : size(A.D.testingset, 1)         % patterns
    % 
    %         outputs(p,:) = A.P.activation_function(A.W.state * A.D.testingset_I(p,:)', A.P.threshold);       
    % %     for r = 1 : A.P.timeout
    % %         previous_output = A.L.output;
    % %         A.L.output = A.P.activation_function(A.W.state * previous_output, A.P.threshold);
    % %         diff = abs(A.L.output - previous_output);
    % %         if diff <= A.P.convergence_threshold
    % %             break
    % %         end
    %     end 
    %     
    case 'covariance2' % same as covariance but mean activity is calculated
                       % per neuron, and not per network
        a = mean(A.D.trainingset);
        arep = repmat(a,A.P.nbof_patterns,1);        
        N = A.P.nbof_patterns;                
        inc = (1./(N*(a'*a))) * ((A.D.trainingset-arep)' * (A.D.trainingset-arep));

        A.W.state = A.W.state / A.P.forgetting_rate;
        A.W.state = A.W.state + A.P.learning_rate * inc;       
        A.W.state(A.W.eliminated) = 0;
    otherwise 
        'Error: learning rule is unknown!'
end