% Script for saving default parameters for different models

clear all
parameterset = 3;
% 1 = Treves-Rolls model with modified parameters
% 2 = Storkey model with original parameters
% 3 = Storkey model with modified parameters

%% 1: Treves modified default parameters

if parameterset == 1 
    
    % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
    P.inputseed = 'noseed';             % random seed for pattern generation
    P.weightseed = 'noseed';            % random seed for generating initial weights
    P.trainingseed = 'noseed';          % random seed for selecting training patterns
    
    % Initialization
    P.weight_init = @zeros;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
    P.strenght_of_memory_traces = 0;    % multiplier of the initial weights
    
    % Architecture
    P.nbof_neurons = 1000;              % number of neurons: 1000
    P.weight_deletion_mode = 'Poisson'; % 'exact', 'probabilistic', 'Poisson'
    P.connection_density = 0.4;         % [0,1]; the proportion of existing weights to all possible weights
    P.activation_function = @transferfn_step;   % @transferfn_threshold_linear [0, Inf], @transferfn_piecewise_linear [0,1], @transferfn_step (0/1), @transferfn_step2 (-1/1)
    P.gain_factor = NaN;                % slope of the threshold linear activation function
    P.threshold = 0;                    % activation threshold for @transferfn_step and @transferfn_threshold_linear; the middle of the linear part for @transferfn_piecewise_linear; starting value when autoupdate enabled
    P.allow_selfloops = 0;              % 0/1; whether to allow self-loops
    
    % Input
    P.nbof_patterns = 120;
    P.lengthof_patterns = P.nbof_neurons;   % the length of patterns; = P.nbof_neurons
    P.sparseness = 0.1;                 % (0,1); proportion of 1s in the input
    P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!
    
    % Training
    P.trained_percentage = 100;         % percentage of selected items for training from the testing set
    P.learning_rule = 'covariance1';        % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2', 'Storkey' (see TrainAttractor)
    P.learning_rate = 1;                % learning rate
    P.forgetting_rate = 0;
    P.autothreshold_aftertraining = 1;  % 0/1; enables automatic threshold after training
    P.threshold_algorithm = @set_threshold_aftertraining_det;        % @set_threshold_aftertraining, ..._dynamic, ..._det
    P.normalize = 0;                     % normalize weights after training?
    %P.sparseness_difference = NaN;      % maximum allowable difference between input and output sparseness wehn setting threshold
    %P.threshold_incr = NaN;             % the increment with which to change the threshold during threshold setting; starting increment when threshold setting is dynamic
    %P.threshold_setting_timeout = NaN;  % maximum number of steps when setting the threshold
    
    % Testing
    P.timeout = 30;                     % the maximum number of recurrent cycles
    P.convergence_threshold = 0;        % convergence threshold for recurrence
    P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
    P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
    P.field_ratio = 0.3;                  % the strength of the external field is s/sparseness
    P.autothreshold_duringtesting = 0;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
    P.noise = 0;                        % the percentage of flipped input bits during testing
    P.missing_perc = 0;                 % the percentage of missing input bits during testing
    
    save('C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\Attractor_params_Treves_modified.mat', 'P')
end

%% 2: Storkey original default parameters

if parameterset == 2 
    
    % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
    P.inputseed = 'noseed';             % random seed for pattern generation
    P.weightseed = 'noseed';            % random seed for generating initial weights
    P.trainingseed = 'noseed';          % random seed for selecting training patterns
    
    % Initialization
    P.weight_init = @zeros;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
    P.strenght_of_memory_traces = 0;    % multiplier of the initial weights
    
    % Architecture
    P.nbof_neurons = 400;              % number of neurons: 1000
    P.weight_deletion_mode = 'probabilistic'; % 'exact', 'probabilistic', 'Poisson'
    P.connection_density = 1;         % [0,1]; the proportion of existing weights to all possible weights
    P.activation_function = @transferfn_step2;   % @transferfn_threshold_linear [0, Inf], @transferfn_piecewise_linear [0,1], @transferfn_step (0/1), @transferfn_step2 (-1/1)
    P.gain_factor = NaN;                % slope of the threshold linear activation function
    P.threshold = 0;                    % activation threshold for @transferfn_step and @transferfn_threshold_linear; the middle of the linear part for @transferfn_piecewise_linear; starting value when autoupdate enabled
    P.allow_selfloops = 0;              % 0/1; whether to allow self-loops
    
    % Input
    P.nbof_patterns = 120;
    P.lengthof_patterns = P.nbof_neurons;   % the length of patterns; = P.nbof_neurons
    P.sparseness = 0.5;                 % (0,1); proportion of 1s in the input
    P.inactive_input = -1;               % the value of inactive inputs: 0 or -1; match it with the transfer function!
    
    % Training
    P.trained_percentage = 100;         % percentage of selected items for training from the testing set
    P.learning_rule = 'Storkey';        % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2', 'Storkey' (see TrainAttractor)
    P.learning_rate = 1;                % learning rate
    P.forgetting_rate = 0;
    P.autothreshold_aftertraining = 0;  % 0/1; enables automatic threshold after training
    P.threshold_algorithm = @NaN;        % @set_threshold_aftertraining, ..._dynamic, ..._det
    P.normalize = 0;                     % normalize weights after training?
    %P.sparseness_difference = NaN;      % maximum allowable difference between input and output sparseness wehn setting threshold
    %P.threshold_incr = NaN;             % the increment with which to change the threshold during threshold setting; starting increment when threshold setting is dynamic
    %P.threshold_setting_timeout = NaN;  % maximum number of steps when setting the threshold
    
    % Testing
    P.timeout = 30;                     % the maximum number of recurrent cycles
    P.convergence_threshold = 0;        % convergence threshold for recurrence
    P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
    P.synchronous_update = 1;           % 0/1; whether to use synchronous or asynchronous update when testing
    P.field_ratio = 0;                  % the strength of the external field is s/sparseness
    P.autothreshold_duringtesting = 0;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
    P.noise = 0;                        % the percentage of flipped input bits during testing
    P.missing_perc = 0;                 % the percentage of missing input bits during testing
    
    save('C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\Attractor_params_Storkey_original.mat', 'P')
end

%% 3: Storkey modified default parameters

if parameterset == 3
    
    % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
    P.inputseed = 'noseed';             % random seed for pattern generation
    P.weightseed = 'noseed';            % random seed for generating initial weights
    P.trainingseed = 'noseed';          % random seed for selecting training patterns
    
    % Initialization
    P.weight_init = @zeros;              % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
    P.strenght_of_memory_traces = 0;    % multiplier of the initial weights
    
    % Architecture
    P.nbof_neurons = 400;              % number of neurons: 1000
    P.weight_deletion_mode = 'probabilistic'; % 'exact', 'probabilistic', 'Poisson'
    P.connection_density = 1;         % [0,1]; the proportion of existing weights to all possible weights
    P.activation_function = @transferfn_step2;   % @transferfn_threshold_linear [0, Inf], @transferfn_piecewise_linear [0,1], @transferfn_step (0/1), @transferfn_step2 (-1/1)
    P.gain_factor = NaN;                % slope of the threshold linear activation function
    P.threshold = 0;                    % activation threshold for @transferfn_step and @transferfn_threshold_linear; the middle of the linear part for @transferfn_piecewise_linear; starting value when autoupdate enabled
    P.allow_selfloops = 0;              % 0/1; whether to allow self-loops
    
    % Input
    P.nbof_patterns = 120;
    P.lengthof_patterns = P.nbof_neurons;   % the length of patterns; = P.nbof_neurons
    P.sparseness = 0.5;                 % (0,1); proportion of 1s in the input
    P.inactive_input = -1;               % the value of inactive inputs: 0 or -1; match it with the transfer function!
    
    % Training
    P.trained_percentage = 100;         % percentage of selected items for training from the testing set
    P.learning_rule = 'Storkey';        % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2', 'Storkey' (see TrainAttractor)
    P.learning_rate = 1;                % learning rate
    P.forgetting_rate = 0;
    P.autothreshold_aftertraining = 1;  % 0/1; enables automatic threshold after training
    P.threshold_algorithm = @set_threshold_aftertraining_det;        % @set_threshold_aftertraining, ..._dynamic, ..._det
    P.normalize = 0;                     % normalize weights after training?
    %P.sparseness_difference = NaN;      % maximum allowable difference between input and output sparseness wehn setting threshold
    %P.threshold_incr = NaN;             % the increment with which to change the threshold during threshold setting; starting increment when threshold setting is dynamic
    %P.threshold_setting_timeout = NaN;  % maximum number of steps when setting the threshold
    
    % Testing
    P.timeout = 30;                     % the maximum number of recurrent cycles
    P.convergence_threshold = 0;        % convergence threshold for recurrence
    P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
    P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
    P.field_ratio = 0;                  % the strength of the external field is s/sparseness
    P.autothreshold_duringtesting = 0;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
    P.noise = 5;                        % the percentage of flipped input bits during testing
    P.missing_perc = 0;                 % the percentage of missing input bits during testing
  
    % Can be further modified: sparseness, connection density, field ratio
    
    save('C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\Attractor_params_Storkey_modified.mat', 'P')
end

%%

'Parameters saved'




