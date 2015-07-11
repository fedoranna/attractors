clear all
addpath(genpath('C:\Users\Anna\SkyDrive\Documents\MATLAB\'));

%% Parameters

% Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
P.inputseed = 'noseed';                    % random seed for pattern generation
P.weightseed = 'noseed';            % random seed for generating initial weights
P.trainingseed = 'noseed';          % random seed for selecting training patterns

% Initialization
P.weight_init = @rand;             % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
P.strenght_of_memory_traces = 0;    % multiplier of the initial weights

% Architecture
P.nbof_neurons = 1000;               % number of neurons: 1000
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
P.learning_rule = 'covariance1';    % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2' (see TrainAttractor)
P.learning_rate = 1;                %%% learning rate
P.autothreshold_aftertraining = 1;  % 0/1; enables automatic threshold after training
P.threshold_algorithm = @set_threshold_aftertraining_det; % @set_threshold_aftertraining, ..._dynamic, ..._det
P.sparseness_difference = NaN;        % maximum allowable difference between input and output sparseness wehn setting threshold
P.threshold_incr = NaN;             % the increment with which to change the threshold during threshold setting; starting increment when threshold setting is dynamic
P.threshold_setting_timeout = NaN;   % maximum number of steps when setting the threshold

% Testing
P.timeout = 30;                     %%% the maximum number of recurrent cycles
P.convergence_threshold = 0;        % convergence threshold for recurrence
P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
P.field_ratio = 0.3;                %%% s, the strength of the external field
P.autothreshold_duringtesting = 0;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
P.noise = 0;                        % the percentage of flipped input bits during testing
P.missing_perc = 0;                 % the percentage of missing input bits during testing

%% Change default parameters

folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\3. Palimpsest memory\uncorrelated patterns\';
% P.inputseed = 1651559639;
% P.weightseed = 1651559654;
% P.trainingseed = 1651559652;

set = 1;
forgetting_rates = 0:0.1:1;

P.nbof_patterns = 10;
P.noise = 5;
criteria = 0.95;

nonrandom = 1;
morefigures = 0;

%% Non-random input

if nonrandom == 1 % This cannot be learnt
    on = P.nbof_neurons * P.sparseness;
    patterns = zeros(P.nbof_patterns,P.nbof_neurons);
    for i = 1:P.nbof_patterns
        patterns(i, (on*(i-1)+1) : (on*i)) = ones(1,on);
    end
end

%% Run

for f = 1:numel(forgetting_rates)
    P.forgetting_rate = forgetting_rates(f);
    'Running...'
    A = InitializeAttractor(P);
    
    if nonrandom > 0
        A.D.testingset = patterns;
        A.D.testingset_O = A.D.testingset;
        A.D.testingset_I = A.D.testingset_O;
        
        % Noisy input
        flippingmatrix = double(rand(size(A.D.testingset_I)) <= (A.P.noise/100));
        A.D.testingset_I = abs(flippingmatrix - A.D.testingset_I);
        
        % Incomplete input
        nbof_deleted = round((A.P.missing_perc/100) * numel(A.D.testingset_O));
        deleted = randperm(numel(A.D.testingset_O), nbof_deleted);
        A.D.testingset_I(deleted) = 0;
        
        A.P.sparseness_input = sparseness(A.D.testingset); % this is the actual (realized) sparseness
    end
    
    scores = NaN(P.nbof_patterns, floor(P.nbof_patterns/set));
    for i = 1:floor(P.nbof_patterns/set)
        A.D.trainingset = A.D.testingset((i-1)*set+1 : set*i, :);
        A = TrainAttractor(A);
        A = TestAttractor(A);
        scores(:,i) = A.T.scores;
        
        %numel(unique(A.W.state))
        %sparseness(A.T.outputs)
        %a = sparseness(A.T.outputs((i-1)*set+1 : set*i, :));
        %b = sparseness(A.T.outputs((floor(P.nbof_patterns/set)-1)*set+1 : set*floor(P.nbof_patterns/set), :));
        %[a,b]
        
    end
    
    %% Save matfile
    
    save([folder, A.P.ID, '.mat'], '-v7.3');
    
    %% Figure: heatmap of scores
    
    figure
    suptitle(['Forgetting rate = ',num2str(P.forgetting_rate),'; Set = ', num2str(set), '; Criteria = ', num2str(criteria)], 10)
    subplot(1,2,1)
    %imagesc(scores, [0.7,1.0])
    imagesc(scores, [0,1])
    %title('Scores')
    ylabel('Patterns')
    xlabel('Training sessions')
    colorbar
    subplot(1,2,2)
    %imagesc(scores>criteria)
    imagesc(scores>criteria, [0,1])
    %title(['Scores > ', num2str(criteria)])
    ylabel('Patterns')
    xlabel('Training sessions')
    colorbar
    %cim = ['palimpsest_', 'P', num2str(P.nbof_patterns),'_set', num2str(set), '_f', num2str(P.forgetting_rate)];
    print('-dpng', '-r200', [folder, A.P.ID, '_palimpsest.png'])
    close
    
    %% More figures
    
    if morefigures == 1
        figure
        hist(A.W.state(:))
        title('Weight distribution after the 1st session')
        print('-dpng', '-r200', [folder, A.P.ID, '_weights1.png'])
        close
        
        figure
        boxplot(scores)
        xlabel('Training sessions')
        ylabel('Scores')
        print('-dpng', '-r200', [folder, A.P.ID, '_scores.png'])
        close
        
        figure % This only works if there were more than 1 pattern and more than 1 session
        toplot = [sum(scores>0.9)',  sum(scores>0.91)', sum(scores>0.92)',  sum(scores>0.93)',  sum(scores>0.94)',  sum(scores>0.95)',  sum(scores>0.96)',  sum(scores>0.97)',  sum(scores>0.98)',  sum(scores>0.99)'];
        boxplot(toplot, 'labels', 0.90:0.01:0.99)
        ylabel('Number of recalled patterns (score > criteria)')
        xlabel('Criteria')
        title(['Training set = ', num2str(set), ' patterns'])
        print('-dpng', '-r200', [folder, A.P.ID, '_boxplots.png'])
        close
        
        figure
        correlations = NaN(P.nbof_patterns);
        for i = 1:P.nbof_patterns
            for j = i+1 : P.nbof_patterns
                corr_matrix = corrcoef(A.D.testingset(i,:), A.D.testingset(j,:));
                correlations(i,j) = corr_matrix(1,2);
            end
        end
        hist(correlations(:))
        xlabel('Correlations')
        ylabel('Number of pairs')
        print('-dpng', '-r200', [folder, A.P.ID, '_correlations.png'])
        close       
        
    end
    
    %% Statistics
    
    % d = diag(scores, 0);
    % d_felette = diag(scores, 1); % trained in the previous session
    % d_alatta = diag(scores,-1); % not trained yet, if set=1; trained together with diag if set>1
    % %boxplot([d1,d2])
    %
    % [h,p] = ttest2(d_felette,d_alatta, 'Tail', 'right'); % d_felette>d_alatta?
    % new_result = [set, P.forgetting_rate, mean(d_felette),mean(d_alatta),p];
    % result=[result;new_result];
    %result
    
end

%% Beep

for i = 1:3
    beep
    pause(0.5)
end

%%
