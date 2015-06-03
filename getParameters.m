%% Parameters

function P = getParameters(v)

switch v
    case 0 % this should be used for experimenting with parameters
        
        
    case 182012 % as in Rolls, 2012; DO NOT CHANGE!!!
        
        % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
        P.inputseed = 'noseed';             % random seed for pattern generation
        P.weightseed = 'noseed';            % random seed for generating initial weights
        P.trainingseed = 'noseed';          % random seed for selecting training patterns
        
        % Initialization
        P.weight_init = @zeros;             % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;    % multiplier of the initial weights
        
        % Architecture
        P.nbof_neurons = 1000;              % number of neurons: 1000
        P.weight_deletion_mode = 'exact';   % 'exact' or 'probabilistic'
        P.connection_density = 0.4;         % [0,1]; the proportion of existing weights to all possible weights
        P.activation_function = @transferfn_threshold_linear;   % @transferfn_threshold_linear [0, Inf], @transferfn_piecewise_linear [0,1], @transferfn_tanh (-1/+1), @transferfn_step (0/1)
        P.gain_factor = 0.5;                % slope of the threshold linear activation function
        P.threshold = 0;                    % activation threshold for @transferfn_step and @transferfn_threshold_linear; starting value when autoupdate enabled
        P.allow_selfloops = 0;              % 0/1; whether to allow self-loops
        
        % Input
        P.lengthof_patterns = P.nbof_neurons;   % the length of patterns; = P.nbof_neurons
        P.nbof_patterns = 40;               % number of patterns in the testing set
        P.sparseness = 0.1;                 % proportion of 1s in the input
        P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!
        
        % Training
        P.trained_percentage = 100;         % percentage of selected items for training from the testing set
        P.learning_rule = 'covariance2';    % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2' (see TrainAttractor)
        P.learning_rate = 1;                % learning rate
        P.forgetting_rate = 1;              % weights are multiplied by this number before each trainig session
        P.autothreshold_aftertraining = 0;  % 0/1; enables automatic threshold after training
        P.sparseness_difference = 0.001;    % maximum allowable difference between input and output sparseness wehn setting threshold
        P.threshold_incr = 0.8;          % the increment with which to change the threshold during threshold setting
        P.threshold_setting_timeout = 500;  % maximum number of steps when setting the threshold
        
        % Testing
        P.timeout = 30;                     % the maximum number of recurrent cycles
        P.convergence_threshold = 0;        % convergence threshold for recurrence
        P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
        P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
        P.field_ratio = 0.3;                % s, the strength of the external field
        P.autothreshold_duringtesting = 1;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
        P.noise = 0;                        % the percentage of flipped input bits during testing
        P.missing_perc = 0;                 % the percentage of missing input bits during testing
        
    case 1820122 % based on Rolls, but optimized for evolution
        %%
        % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
        P.inputseed = 'noseed';             % random seed for pattern generation
        P.weightseed = 'noseed';            % random seed for generating initial weights
        P.trainingseed = 'noseed';          % random seed for selecting training patterns
        
        % Initialization
        P.weight_init = @zeros;             %%% @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;    %%% multiplier of the initial weights
        
        % Architecture
        P.nbof_neurons = 25;               % number of neurons: 1000
        P.weight_deletion_mode = 'probabilistic';   % 'exact' or 'probabilistic'
        P.connection_density = 0.4;         % [0,1]; the proportion of existing weights to all possible weights
        P.activation_function = @transferfn_step;   % @transferfn_threshold_linear [0, Inf], @transferfn_piecewise_linear [0,1], @transferfn_tanh (-1/+1), @transferfn_step (0/1)
        P.gain_factor = 0.5;                % slope of the threshold linear activation function
        P.threshold = 0;                    % activation threshold for @transferfn_step and @transferfn_threshold_linear; starting value when autoupdate enabled
        P.allow_selfloops = 0;              % 0/1; whether to allow self-loops
        
        % Input
        P.lengthof_patterns = P.nbof_neurons;   % the length of patterns; = P.nbof_neurons
        P.nbof_patterns = 4;                %%% number of patterns in the testing set
        P.sparseness = 0.1;                 % proportion of 1s in the input
        P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!
        
        % Training
        P.trained_percentage = 100;         % percentage of selected items for training from the testing set
        P.learning_rule = 'covariance2';    % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2' (see TrainAttractor)
        P.learning_rate = 1;              %%% learning rate
        P.forgetting_rate = 1;            %%% weights are multiplied by this number before each trainig session
        P.autothreshold_aftertraining = 0;  % 0/1; enables automatic threshold after training
        P.sparseness_difference = 0.001;    % maximum allowable difference between input and output sparseness wehn setting threshold
        P.threshold_incr = 0.8;             % the increment with which to change the threshold during threshold setting
        P.threshold_setting_timeout = 500;  % maximum number of steps when setting the threshold
        
        % Testing
        P.timeout = 30;                     % the maximum number of recurrent cycles
        P.convergence_threshold = 0;        % convergence threshold for recurrence
        P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
        P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
        P.field_ratio = 0.3;                % s, the strength of the external field
        P.autothreshold_duringtesting = 1;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
        P.noise = 0;                        % the percentage of flipped input bits during testing
        P.missing_perc = 0;                 % the percentage of missing input bits during testing
        %%      
    case 1820123 % based on Rolls, but optimized for performance
        % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
        P.inputseed = 'noseed';             % random seed for pattern generation
        P.weightseed = 'noseed';            % random seed for generating initial weights
        P.trainingseed = 'noseed';          % random seed for selecting training patterns
        
        % Initialization
        P.weight_init = @zeros;             % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
        P.strenght_of_memory_traces = 0;    % multiplier of the initial weights
        
        % Architecture
        P.nbof_neurons = 100;              % number of neurons: 1000
        P.weight_deletion_mode = 'probabilistic';   % 'exact' or 'probabilistic'
        P.connection_density = 0.4;         %%% [0,1]; the proportion of existing weights to all possible weights
        P.activation_function = @transferfn_step;   % @transferfn_threshold_linear [0, Inf], @transferfn_piecewise_linear [0,1], @transferfn_tanh (-1/+1), @transferfn_step (0/1)
        P.gain_factor = 0.5;                % slope of the threshold linear activation function
        P.threshold = 0;                    % activation threshold for @transferfn_step and @transferfn_threshold_linear; starting value when autoupdate enabled
        P.allow_selfloops = 0;              % 0/1; whether to allow self-loops
        
        % Input
        P.lengthof_patterns = P.nbof_neurons;   % the length of patterns; = P.nbof_neurons
        P.nbof_patterns = 4;               %%% number of patterns in the testing set
        P.sparseness = 0.1;                 %%% proportion of 1s in the input
        P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!
        
        % Training
        P.trained_percentage = 100;         % percentage of selected items for training from the testing set
        P.learning_rule = 'covariance2';    % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2' (see TrainAttractor)
        P.learning_rate = 1;              %%% learning rate
        P.forgetting_rate = 1;              % weights are multiplied by this number before each trainig session
        P.autothreshold_aftertraining = 0;  % 0/1; enables automatic threshold after training
        P.sparseness_difference = 0.001;    %%% maximum allowable difference between input and output sparseness wehn setting threshold
        P.threshold_incr = 0.8;             %%% the increment with which to change the threshold during threshold setting
        P.threshold_setting_timeout = 500; %%% maximum number of steps when setting the threshold
        
        % Testing
        P.timeout = 30;                     %%% the maximum number of recurrent cycles
        P.convergence_threshold = 0;        % convergence threshold for recurrence
        P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
        P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
        P.field_ratio = 0.3;                %%% s, the strength of the external field
        P.autothreshold_duringtesting = 1;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
        P.noise = 10;                        % the percentage of flipped input bits during testing
        P.missing_perc = 0;                 % the percentage of missing input bits during testing
        
    otherwise
        'Error: Parameter set was not found!'
end


























