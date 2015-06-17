

%% P

clear all
addpath(genpath('C:\Matlab_functions\Attractor\'));

% Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
P.inputseed = 2;             % random seed for pattern generation
P.weightseed = 2;            % random seed for generating initial weights
P.trainingseed = 2;          % random seed for selecting training patterns

% Initialization
P.weight_init = @rand;             % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
P.strenght_of_memory_traces = 0;    % multiplier of the initial weights

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
P.forgetting_rate = 0;
P.autothreshold_aftertraining = 1;  % 0/1; enables automatic threshold after training
P.threshold_algorithm = @set_threshold_aftertraining_det; % @set_threshold_aftertraining, ..._dynamic, ..._det
P.sparseness_difference = 0.0001;        % maximum allowable difference between input and output sparseness wehn setting threshold
P.threshold_incr = 0.1;             % the increment with which to change the threshold during threshold setting; starting increment when threshold setting is dynamic
P.threshold_setting_timeout = 500;   % maximum number of steps when setting the threshold

% Testing
P.timeout = 30;                     %%% the maximum number of recurrent cycles
P.convergence_threshold = 0;        % convergence threshold for recurrence
P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
P.field_ratio = 0.3;                %%% s, the strength of the external field
P.autothreshold_duringtesting = 0;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
P.missing_perc = 0;                 % the percentage of missing input bits during testing

%% Variable parameters

folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\2. Modified Rolls model\';
P.noise = 5;                        % the percentage of flipped input bits in the cloud
P.nbof_patterns = 100;               % the number of patterns in the cloud
mode = 2;
% mode 1: test with independent random patterns
% mode 2: train with prototype, test with cloud
% mode 3: train with cloud, test with prototype

% P.autothreshold_aftertraining = 0;  % 0/1; enables automatic threshold after training
% P.threshold_algorithm = @set_threshold_aftertraining; % @set_threshold_aftertraining, ..._dynamic, ..._det
% P.autothreshold_duringtesting = 1;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing

%% Patterns with prototype structure

if strcmp(P.inputseed, 'noseed')
    rng shuffle
    s = rng;
    P.inputseed = s.Seed;
    rng(P.inputseed, 'twister');
else
    rng(P.inputseed, 'twister');
end

prototype1 = double(rand(1, P.lengthof_patterns) <= P.sparseness);
prototype2 = double(rand(1, P.lengthof_patterns) <= P.sparseness);

flippingmatrix1 = double(rand(P.nbof_patterns, P.lengthof_patterns)) <= (P.noise/100);
flippingmatrix2 = double(rand(P.nbof_patterns, P.lengthof_patterns)) <= (P.noise/100);

cloud1 = abs(flippingmatrix1 - repmat(prototype1, P.nbof_patterns, 1));
cloud2 = abs(flippingmatrix2 - repmat(prototype2, P.nbof_patterns, 1));

H = NaN(P.nbof_patterns, 4);
for i = 1:P.nbof_patterns
    H(i,1) = Hamming_distance(prototype1, cloud1(i,:));
    H(i,2) = Hamming_distance(prototype1, cloud2(i,:));
    H(i,3) = Hamming_distance(prototype2, cloud2(i,:));
    H(i,4) = Hamming_distance(prototype2, cloud1(i,:));
end
mean(H);

% figure
% boxplot(H, 'labels', {'Prototype1 - cloud 1', 'Prototype1 - cloud 2', 'Prototype2 - cloud 2', 'Prototype2 - cloud 1',})
% ylabel('Average Hamming distance')
% close

%% Trainingset and testingset in different modes

A = InitializeAttractor(P);
switch mode
    
    case 1 % train with 1 pattern, test with independent random patterns
        A.D.trainingset = prototype1;
        A.D.testingset = double(rand(P.nbof_patterns, P.lengthof_patterns) <= P.sparseness);
        
    case 2 % train with prototype, test with cloud
        A.D.trainingset = [prototype1; prototype2];
        A.D.testingset = [cloud1; cloud2];
        
    case 3 % train with cloud, test with prototype
        A.D.trainingset = [cloud1; cloud2];
        A.D.testingset = [prototype1; prototype2];
end

A.D.testingset_I = A.D.testingset;
A.D.testingset_O = A.D.testingset;
A = TrainAttractor(A);
A = TestAttractor(A);

%% Results

switch mode
    case 1
        
        C = NaN(size(A.T.outputs,1),2);
        for i = 1:size(A.T.outputs,1)
            corr_matrix = corrcoef(A.T.outputs(i,:), A.D.testingset_I(i,:));
            C(i,1) = corr_matrix(1,2);
            corr_matrix = corrcoef(A.T.outputs(i,:), A.D.trainingset);
            C(i,2) = corr_matrix(1,2);
        end
        
        boxplot(C, 'notch', 'on', 'labels', {'With input pattern'; 'With training pattern'})
        ylabel('Correlation of output')
        cim = 'Trained with one pattern, tested with random patterns';
        title(cim)
        print('-dpng', [folder, 'attractorbasins_', cim, '.png'])
        
    case 2
        C = NaN(size(A.T.outputs,1),2);
        for i = 1:size(A.T.outputs,1)
            corr_matrix = corrcoef(A.T.outputs(i,:), prototype1);
            C(i,1) = corr_matrix(1,2);
            corr_matrix = corrcoef(A.T.outputs(i,:), prototype2);
            C(i,2) = corr_matrix(1,2);
        end
        C = [C(1:P.nbof_patterns,:), C(P.nbof_patterns+1 : end, :)];
        
        labels_row1 =  {'Output with cloud 1', 'Output with cloud 1', 'Output with cloud 2', 'Output with cloud 2'};
        labels_row2 =  {'- prototype 1', '- prototype 2', '- prototype 1', '- prototype 2'};
        labels = {labels_row1; labels_row2};
        
        boxplot(C, 'notch', 'on', 'labels', labels)
        ylabel('Correlation of output')
        cim = 'Trained with two prototypes, tested with clouds';
        title(cim)
        print('-dpng', [folder, 'attractorbasins_', cim, '.png'])
        
    case 3
        C = NaN(size(A.T.outputs,1),2);
        for i = 1:size(A.T.outputs,1)
            corr_matrix = corrcoef(A.T.outputs(i,:), prototype1);
            C(i,1) = corr_matrix(1,2);
            corr_matrix = corrcoef(A.T.outputs(i,:), prototype2);
            C(i,2) = corr_matrix(1,2);
        end
        C = [C(1,:), C(2,:)];

%         labels_row1 = {'Output with prototype 1', 'Output with prototype 1', 'Output with prototype 2', 'Output with prototype 2'};
%         labels_row2 = {'- prototype 1', '- prototype 2', '- prototype 1', '- prototype 2'};
%         labels = [labels_row1, labels_row2];
        labels = {'Output with prototype 1 - prototype 1', 'Output with prototype 1 - prototype 2', 'Output with prototype 2 - prototype 1', 'Output with prototype 2 - prototype 2'};

        plot(C, '*r')
        xlim([0,5])
        set(gca, 'XTick', 1:4, 'XTickLabel', labels)
        ylabel('Correlation of output')
        cim = 'Trained with two clouds, tested with prototypes';
        title(cim)
        print('-dpng', [folder, 'attractorbasins_', cim, '.png'])
        
end
close
%%

size(A.D.trainingset,1);
[V,D] = eig(A.W.state, 'nobalance'); % columns of V are the eigenvectors, values on the diagonal of D are the eigenvalues

i=1;
A.W.state * V(:,i) == V(:,i) * D(i,i)















