%% Parameters

function P = getParameters(v)

switch v
    case 0 % this should be used for experimenting with parameters
    
        % Random seeds                      % 'noseed' or a number from 0 to 2^31-2;
        P.inputseed = 'noseed';
        P.weightseed = 'noseed';    
        P.trainingseed = 'noseed';

        % Initialization
        P.weight_init = @zeros;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;   % multiplier of rand weights

        % Architecture
        P.nbof_neurons = 5;               % number of neurons
        P.connection_density = 0.5;           % = dilution; proportion of existing weights to all possible weights; 0 to 1
        P.activation_function = @transferfn_step;      % @transferfn_tanh (-1/+1), @transferfn_step (0/1)
        P.threshold = 0;                   % activation threshold for transferfn_step
        P.allow_selfloops = 1;              % whether to allow self-loops; 1/0

        % Input    
        P.nbof_patterns = 3;               % number of patterns in the testing set
        P.lengthof_patterns = P.nbof_neurons; % the length of patterns; = P.nbof_neurons
        P.sparseness = 0.5;                 % proportion of 1s in the input
        P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!

        % Training
        P.trained_percentage = 100;          % percentage of selected items for training from the testing set
        P.learning_rule = 'Hebbian1';     % 'Hebbian1', 'Hebbian2', or 'covariance'
        P.learning_rate = 1;                % multiplier of the increment
        P.forgetting_rate = 1;             % weights are multiplied by this number before each trainig session

        % Testing    
        P.timeout = 100;                    % the maximum number of recurrent cycles
        P.convergence_threshold = 0;        % convergence for recurrence
    
    case 1 % as in Rolls, 2012; threshold set manually

        % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;                      
        P.inputseed = 'noseed';
        P.weightseed = 'noseed'; 
        P.trainingseed = 'noseed';

        % Initialization
        P.weight_init = @rand;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;   % multiplier of rand weights

        % Architecture
        P.nbof_neurons = 100;               % number of neurons
        P.connection_density = 1;           % proportion of existing weights to all possible weights; 0 to 1
        P.activation_function = @transferfn_step;      % @transferfn_tanh (-1/+1), @transferfn_step (0/1)
        P.threshold = 13;                  % activation threshold for transferfn_step
        P.allow_selfloops = 1;              % whether to allow self-loops; 1/0

        % Input    
        P.nbof_patterns = 50;                % number of patterns in the testing set
        P.lengthof_patterns = P.nbof_neurons; % the length of patterns; = P.nbof_neurons
        P.sparseness = 0.1;                 % proportion of 1s in the input
        P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!

        % Training
        P.trained_percentage = 60;         % percentage of selected items for training from the testing set
        P.learning_rule = 'covariance';        % 'Hebbian1', 'Hebbian2', or 'covariance'
        P.learning_rate = 1;
        P.forgetting_rate = 1;             % weights are multiplied by this number before each trainig session

        % Testing    
        P.timeout = 100;                      % the maximum number of recurrent cycles
        P.convergence_threshold = 0;        % convergence for recurrence
    
    case 2 % -1/+1 neurons and simple learning, no memory traces
    
        % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
        P.weightseed = 'noseed';                   
        P.inputseed = 'noseed';
        P.trainingseed = 'noseed';

        % Initialization
        P.weight_init = @rand;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;   % multiplier of rand weights

        % Architecture
        P.nbof_neurons = 100;                % number of neurons
        P.connection_density = 1;           % proportion of existing weights to all possible weights; 0 to 1
        P.activation_function = @transferfn_tanh;      % DOES NOT WORK @tanh (-1/+1), @transferfn_step (0/1)
        P.threshold = 0.5;                  % activation threshold for transferfn_step
        P.allow_selfloops = 1;              % whether to allow self-loops; 1/0

        % Input    
        P.nbof_patterns = 50;                % number of patterns in the testing set
        P.lengthof_patterns = P.nbof_neurons; % the length of patterns; = P.nbof_neurons
        P.sparseness = 0.5;                 % proportion of 1s in the input
        P.inactive_input = -1;               % the value of inactive inputs: 0 or -1; match it with the transfer function!

        % Training
        P.trained_percentage = 100;         % percentage of selected items for training from the testing set
        P.learning_rule = 'Hebbian1';        % 'Hebbian1', 'Hebbian2', or 'covariance'
        P.learning_rate = 1;
        P.forgetting_rate = 1;             % weights are multiplied by this number before each trainig session

        % Testing    
        P.timeout = 100;                      % the maximum number of recurrent cycles
        P.convergence_threshold = 0;        % convergence for recurrence

    case 111 % for presentation
    
        % Random seeds                      % 'noseed' or a number from 0 to 2^31-2;
        P.inputseed = 'noseed';
        P.weightseed = 'noseed';    
        P.trainingseed = 'noseed';

        % Initialization
        P.weight_init = @zeros;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;   % multiplier of rand weights

        % Architecture
        P.nbof_neurons = 100;               % number of neurons
        P.connection_density = 1;           % = dilution; proportion of existing weights to all possible weights; 0 to 1
        P.activation_function = @transferfn_step;      % @transferfn_tanh (-1/+1), @transferfn_step (0/1)
        P.threshold = 13;                   % activation threshold for transferfn_step
        P.allow_selfloops = 1;              % whether to allow self-loops; 1/0

        % Input    
        P.nbof_patterns = 50;                % number of patterns in the testing set
        P.lengthof_patterns = P.nbof_neurons; % the length of patterns; = P.nbof_neurons
        P.sparseness = 0.1;                 % proportion of 1s in the input
        P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!

        % Training
        P.trained_percentage = 50;          % percentage of selected items for training from the testing set
        P.learning_rule = 'covariance2';     % 'Hebbian1', 'Hebbian2', or 'covariance'
        P.learning_rate = 0.1;                % multiplier of the increment
        P.forgetting_rate = 1;             % weights are multiplied by this number before each trainig session

        % Testing    
        P.timeout = 100;                     % the maximum number of recurrent cycles
        P.convergence_threshold = 0;        % convergence for recurrence
        
    case 81982 % based on Hopfield, 1982 as described in Rolls, 2012
        
        % Random seeds                      % 'noseed' or a number from 0 to 2^31-2;
        P.inputseed = 'noseed';
        P.weightseed = 'noseed';    
        P.trainingseed = 'noseed';

        % Initialization
        P.weight_init = @zeros;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;   % multiplier of rand weights

        % Architecture
        P.nbof_neurons = 100;               % number of neurons
        P.connection_density = 1;           % = dilution; proportion of existing weights to all possible weights; 0 to 1
        P.activation_function = @transferfn_step;      % @transferfn_tanh (-1/+1), @transferfn_step (0/1)
        P.threshold = 0;                   % activation threshold for transferfn_step
        P.allow_selfloops = 0;              % whether to allow self-loops; 1/0

        % Input    
        P.nbof_patterns = 5;               % number of patterns in the testing set
        P.lengthof_patterns = P.nbof_neurons; % the length of patterns; = P.nbof_neurons
        P.sparseness = 0.5;                 % proportion of 1s in the input
        P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!

        % Training
        P.trained_percentage = 100;          % percentage of selected items for training from the testing set
        P.learning_rule = 'covariance2';     % 'Hebbian1', 'Hebbian2', or 'covariance1'
        P.learning_rate = 1;                % multiplier of the increment
        P.forgetting_rate = 1;             % weights are multiplied by this number before each trainig session

        % Testing    
        P.timeout = 100;                    % the maximum number of recurrent cycles
        P.convergence_threshold = 0;        % convergence for recurrence
    
    otherwise
        'Error: Parameter set was not found!'
end


























