%% Batch parameters

clear all

B.beeps = 0;
B.folder = 'C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\RESULTS\7. Trees\';
B.save2excel = 0;
B.save_matfile = 1;
B.save_plot = 1;
B.save_movie = 1;
B.repetitions = 1;                  % number of independent runs
B.popseeds = [1:B.repetitions];     % 704; random seed of independent runs

%% Population parameters

S.task = 'trees';                   % Name of the task
S.nbof_generations = 200;             % maximum number of generations
S.popsize = 100;                     % number of attractor networks in the population
S.selection_type = 'elitist';       % 'elitist'
S.selected_perc = 3;               % [0, 100]; the selected percentage of individuals for reproduction
S.fitness_measure = 'fitness_side'; % choose from the fields of T - see in calculate_performance fn
S.random_training_order = 1;        % the selected patterns are fed back to the networks randomly for retraining
S.random_testing_order = 1;         % the selected patterns are fed back to the networks randomly for provoking
S.mutation_rate = 0.03;            % probability of mutation/bit during reproduction
S.retraining = 0.7;                   % [0, 1]; probability of retraining each network in each generation with the selected outputs after the first phase
S.nbof_testingpatterns = 1;         % The number of initial provoking patterns per network (the same as the number of rows in the solution)
S.pretrain_solution = 0;            % 1: the solution is used as the first trainingpattern of the first network in the population; 0: the solution is unknown to all networks
S.forgetting_rate = 0;              % [0, 1]; weights are multiplied by 1-S.forgetting_rate before retraining
S.save_pop = 0;                     % 1: save the whole population in G; 0: only save the last generation
S.print2screen = 1;
S.stopping_fitness = 1;
S.switchingprob_a=0.7;
S.switchingprob_b=0.03;
S.switchingprob_c=1;

%% Network parameters

% Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
P.inputseed = 'noseed';             % random seed for testingpattern generation
P.weightseed = 'noseed';            % random seed for generating initial weights
P.trainingseed = 'noseed';          % random seed for trainingpattern generation

% Initialization
P.weight_init = @zeros;             % @zeros, @rand, @ones (@randn can be negative!); with Hebbian2 + @zeros the network does not learn!
P.strenght_of_memory_traces = 0;    % multiplier of the initial weights

% Architecture
P.nbof_neurons = 300;               % number of neurons: 300 for Task = trees
P.connection_density = 1;           % [0,1]; the proportion of existing weights to all possible weights
P.weight_deletion_mode = 'probabilistic'; % 'exact', 'probabilistic', 'Poisson'
P.activation_function = @transferfn_step2;   % @transferfn_threshold_linear [0, Inf], @transferfn_piecewise_linear [0,1], @transferfn_step (0/1), @transferfn_step2 (-1/1)
P.gain_factor = NaN;                % slope of the threshold linear activation function
P.threshold = 0;                    % activation threshold for @transferfn_step and @transferfn_threshold_linear; the middle of the linear part for @transferfn_piecewise_linear; starting value when autoupdate enabled
P.allow_selfloops = 0;              % 0/1; whether to allow self-loops

% Input
P.sparseness_provoking = [0.38, 0.5, 0]; % sparseness of pretraining patterns (first, second and third third)
P.lengthof_patterns = P.nbof_neurons;% the length of patterns;
P.inactive_input = -1;              % the value of inactive inputs: 0 or -1; match it with the transfer function!
P.side_tetrahedron = 80;            % the size of the sides of the regular tetrahedron
P.apex_tetrahedron = [15,10,0];     % [x,y,z] coordinates of the first apex of the tetrahedron

% Training
P.sparseness_pretraining = [0.5, 0.5, 0]; % sparseness of pretraining patterns (first, second and third third)
P.nbof_pretrainingpatterns = 90;    % nb of pretraining patterns
P.learning_rule = 'Storkey_bypattern';        % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2', 'Storkey' (see TrainAttractor)
P.learning_rate = 1;                % learning rate
P.forgetting_rate = 0.1;              % multiplier of weights before learning
P.autothreshold_aftertraining = 0;  % 0/1; enables automatic threshold after training
P.threshold_algorithm = @set_threshold_aftertraining_det;       % function to set the activation threshold
P.normalize = 0;                    % normalize weights after training

% Testing
P.lengthof_position = 3;            % length of vector that is calculated from the activation patterns
P.timeout = 33;                     % the maximum number of recurrent cycles
P.convergence_threshold = 0;        % convergence threshold for recurrence
P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
P.update_each = 0;                  % update each neuron once, or update neurons wth replacement during asynchronous update
P.noise = 0;                        % probability of noisy (flipped) bit in input
P.missing_perc = 0;                 % percentage of missing bits in input

%% Save

save('C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\params_trees_5.mat', 'B', 'S', 'P')