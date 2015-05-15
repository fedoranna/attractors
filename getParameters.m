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
        P.tolerance = 0.1;                  % tolerance for the difference between output and active/inactive values
    
    case 1 % -1/+1 neurons and simple learning, no memory traces
    
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

    case 111 % for Lausanne presentation
    
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
        P.tolerance = 0.1;                  % tolerance for the difference between output and active/inactive values
        
    case 81982 % based on Hopfield, 1982 as described in Rolls, 2012
        
        % Random seeds                      % 'noseed' or a number from 0 to 2^31-2;
        P.inputseed = 'noseed';
        P.weightseed = 'noseed';    
        P.trainingseed = 'noseed';

        % Initialization
        P.weight_init = @zeros;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;   % multiplier of rand weights

        % Architecture
        P.nbof_neurons = 5;               % number of neurons
        P.connection_density = 1;           % = dilution; proportion of existing weights to all possible weights; 0 to 1
        P.activation_function = @transferfn_step;      % @transferfn_tanh (-1/+1), @transferfn_step (0/1)
        P.threshold = 0;                   % activation threshold for transferfn_step
        P.allow_selfloops = 0;              % whether to allow self-loops; 1/0

        % Input    
        P.nbof_patterns = 1;               % number of patterns in the testing set
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
        P.tolerance = 0.1;                  % tolerance for the difference between output and active/inactive values
        
    case 182012 % as in Rolls, 2012
%%
        % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;                      
        P.inputseed = 'noseed';
        P.weightseed = 'noseed'; 
        P.trainingseed = 'noseed';

        % Initialization
        P.weight_init = @zeros;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;   % multiplier of rand weights

        % Architecture
        P.nbof_neurons = 1000;               % number of neurons: 1000
        P.connection_density = [];           % probabilistic; proportion of existing weights to all possible weights; 0 to 1
        %P.connections_per_neuron = round(P.nbof_neurons/2); % the exact number of connections per neuron for each neuron
        P.activation_function = @transferfn_step;      % @transferfn_tanh (-1/+1), @transferfn_step (0/1)
        P.gain_factor = 0.5;              % slope of the threshold linear activation function
        P.threshold = 0;                  % activation threshold for transferfn_step; starting value when autoupdate enabled
        P.allow_selfloops = 0;              % whether to allow self-loops; 1/0

        % Input    
        P.nbof_patterns = 40;                % number of patterns in the testing set
            P.loading = 10;                      % loading = nbof_patterns/connections_per_neuron
            P.connections_per_neuron = P.nbof_patterns*P.loading; % the exact number of connections per neuron for each neuron
        P.lengthof_patterns = P.nbof_neurons; % the length of patterns; = P.nbof_neurons
        P.sparseness = 0.1;                 % proportion of 1s in the input
        P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!
        
        % Training
        P.trained_percentage = 100;         % percentage of selected items for training from the testing set
        P.learning_rule = 'covariance2';        % 'Hebbian1', 'Hebbian2', or 'covariance'
        P.learning_rate = 1;                % learning rate
        P.forgetting_rate = 1;             % weights are multiplied by this number before each trainig session
        P.autothreshold_aftertraining = 0;          % 1/0; automatic threshold after training
        P.autothreshold_duringtesting = 1;
        P.sparseness_difference = 0.001;      % maximum allowable difference between input and output sparseness wehn setting threshold
        P.threshold_incr = 0.0001;             % the increment with which to change the threshold during threshold setting
        P.threshold_setting_timeout = 100; % maximum number of steps when setting the threshold

        % Testing    
        P.timeout = 30;                      % the maximum number of recurrent cycles
        P.convergence_threshold = 0;        % convergence for recurrence
        P.tolerance = 0.1;                  % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
        P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
        P.field_ratio = 0.25;             % external field / internal field, see Rolls, 2012
        P.noise = 0.001;        % size of noise when testing_type is 'noisy'
        P.missing_perc = 0.5;                % the percentage of missing input bits when testing_type is 'incomplete'
        
        %%
    otherwise
        'Error: Parameter set was not found!'
end


























