
%% Parameters

% Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
P.inputseed = 1;             % random seed for pattern generation
P.weightseed = 1;            % random seed for generating initial weights
P.trainingseed = 1;          % random seed for selecting training patterns

% Initialization
P.weight_init = @rand;             % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!

% Architecture
P.nbof_neurons = 100;               % number of neurons: 1000
P.weight_deletion_mode = 'Poisson';   % 'exact', 'probabilistic', 'Poisson'
P.connection_density = 0.4;         %%% [0,1]; the proportion of existing weights to all possible weights
P.activation_function = @transferfn_step;   % @transferfn_threshold_linear [0, Inf], @transferfn_piecewise_linear [0,1], @transferfn_step (0/1)
P.gain_factor = 0.5;                % slope of the threshold linear activation function
P.threshold = 0;                    % activation threshold for @transferfn_step and @transferfn_threshold_linear; the middle of the linear part for @transferfn_piecewise_linear; starting value when autoupdate enabled
P.allow_selfloops = 0;              % 0/1; whether to allow self-loops

% Input
P.lengthof_patterns = P.nbof_neurons;   % the length of patterns; = P.nbof_neurons
P.sparseness = 0.1;                 %%% proportion of 1s in the input
P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!

% Training
P.trained_percentage = 100;         % percentage of selected items for training from the testing set
P.learning_rule = 'covariance2';    % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2' (see TrainAttractor)
P.learning_rate = 1;                %%% learning rate
P.autothreshold_aftertraining = 1;  % 0/1; enables automatic threshold after training
P.threshold_algorithm = @set_threshold_aftertraining_det; % @set_threshold_aftertraining, ..._dynamic, ..._det
P.sparseness_difference = 0;        % maximum allowable difference between input and output sparseness wehn setting threshold
P.threshold_incr = 0.1;             % the increment with which to change the threshold during threshold setting; starting increment when threshold setting is dynamic
P.threshold_setting_timeout = 50;   % maximum number of steps when setting the threshold

% Testing
P.timeout = 30;                     %%% the maximum number of recurrent cycles
P.convergence_threshold = 0;        % convergence threshold for recurrence
P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
P.field_ratio = 0.3;                %%% s, the strength of the external field
P.autothreshold_duringtesting = 0;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
P.missing_perc = 10;                 % the percentage of missing input bits during testing

%% Run one attractor

P.strenght_of_memory_traces = 0;    % multiplier of the initial weights
P.noise = 5;                        % the percentage of flipped input bits during testing

P.nbof_patterns = 10;               %%% number of patterns in the testing set
set = 2;
P.forgetting_rate = 0.5;

A = InitializeAttractor(P);
scores = NaN(P.nbof_patterns, floor(P.nbof_patterns/set));
for i = 1:floor(P.nbof_patterns/set)
    A.D.trainingset = A.D.testingset((i-1)*set+1 : set*i,:);
    A = TrainAttractor(A);
    A = TestAttractor(A);
    scores(:,i) = A.T.scores;
end

%% Figure

figure
suptitle(['Forgetting rate = ',num2str(P.forgetting_rate),'; set = ', num2str(set)])
subplot(1,2,1)
imagesc(scores)
title('Scores')
colorbar
axis('square')
subplot(1,2,2)
imagesc(scores>0.95)
title('Scores > 0.95')
colorbar
axis('square')

cim = ['palimpsest_', 'P', num2str(P.nbof_patterns),'_set', num2str(set), '_f', num2str(P.forgetting_rate)];
folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\2. Modified Rolls model\';
print('-dpng', '-r200', [folder, cim, '.png'])
%close

%% Statistics

% d = diag(scores, 0);
% d_felette = diag(scores, 1); % trained in the previous session
% d_alatta = diag(scores,-1); % not trained yet, if set=1; trained together with diag if set>1
% %boxplot([d1,d2])
% 
% [h,p] = ttest2(d_felette,d_alatta, 'Tail', 'right'); % d_felette>d_alatta?
% new_result = [set, P.forgetting_rate, mean(d_felette),mean(d_alatta),p];
% result=[result;new_result];
result


