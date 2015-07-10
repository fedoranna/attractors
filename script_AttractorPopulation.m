clear all
addpath(genpath('C:\Users\Anna\SkyDrive\Documents\MATLAB\'));

S.mode = 's'; % selection or individuals

%% P
%         % Random seeds                      % 'noseed' or a number bw 0 and 2^31-2;
%         P.inputseed = 'noseed';             % random seed for pattern generation
%         P.weightseed = 'noseed';            % random seed for generating initial weights
%         P.trainingseed = 'noseed';          % random seed for selecting training patterns
%         
%         % Initialization
%         P.weight_init = @zeros;             % @zeros, @rand, @ones (@randn can be negative); with Hebbian2 + @zeros the network does not learn!
%         P.strenght_of_memory_traces = 0;    % multiplier of the initial weights
%         
%         % Architecture
%         P.nbof_neurons = 100;               % number of neurons: 1000
%         P.weight_deletion_mode = 'Poisson';   % 'exact', 'probabilistic', 'Poisson'
%         P.connection_density = 0.4;         %%% [0,1]; the proportion of existing weights to all possible weights
%         P.activation_function = @transferfn_piecewise_linear;   % @transferfn_threshold_linear [0, Inf], @transferfn_piecewise_linear [0,1], @transferfn_step (0/1)
%         P.gain_factor = 0.5;                % slope of the threshold linear activation function
%         P.threshold = 0;                    % activation threshold for @transferfn_step and @transferfn_threshold_linear; the middle of the linear part for @transferfn_piecewise_linear; starting value when autoupdate enabled
%         P.allow_selfloops = 0;              % 0/1; whether to allow self-loops
%         
%         % Input
%         P.lengthof_patterns = P.nbof_neurons;   % the length of patterns; = P.nbof_neurons
%         P.nbof_patterns = 10;               %%% number of patterns in the testing set
%         P.sparseness = 0.3;                 %%% proportion of 1s in the input
%         P.inactive_input = 0;               % the value of inactive inputs: 0 or -1; match it with the transfer function!
%         
%         % Training
%         P.trained_percentage = 100;         % percentage of selected items for training from the testing set
%         P.learning_rule = 'covariance2';    % 'Hebbian1', 'Hebbian2', 'covariance1', 'covariance2' (see TrainAttractor)
%         P.learning_rate = 1;                %%% learning rate
%         P.forgetting_rate = 1;              % weights are multiplied by this number before each trainig session
%         P.autothreshold_aftertraining = 1;  % 0/1; enables automatic threshold after training
%         P.threshold_algorithm = @set_threshold_aftertraining_det; % @set_threshold_aftertraining, ..._dynamic, ..._det
%         P.sparseness_difference = 0;        % maximum allowable difference between input and output sparseness wehn setting threshold
%         P.threshold_incr = 0.1;             % the increment with which to change the threshold during threshold setting; starting increment when threshold setting is dynamic
%         P.threshold_setting_timeout = 50;   % maximum number of steps when setting the threshold
%         
%         % Testing
%         P.timeout = 30;                     %%% the maximum number of recurrent cycles
%         P.convergence_threshold = 0;        % convergence threshold for recurrence
%         P.tolerance = 0;                    % if>0 then binarizes output; tolerance for the difference between output and active/inactive values
%         P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
%         P.field_ratio = 0.3;                %%% s, the strength of the external field
%         P.autothreshold_duringtesting = 0;  % 0/1; automatically set thresholds separately for each neuron after each recurrent cycle during testing
%         P.noise = 0;                        % the percentage of flipped input bits during testing
%         P.missing_perc = 0;                 % the percentage of missing input bits during testing

%% Parameters for selection

if S.mode == 's'
    beeps = 3;
    S.folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\3. Selection\';
    save2excel = 1;
    save_matfile = 0;
    save_plot = 1;
    
    repetitions = 1;
    S.popsize = 1000;                    % number of attractor networks in the population
    S.nbof_generations = 50;             % number of generations of attractor networks
    S.selection_type = 'truncation';    % 'truncation'
    S.selected_perc = 10;               % [0, 100]; the selected percentage of individuals for reproduction
    S.nbof_global_testingpatterns = 1; % the number of global testing patterns; if 0 then each individual is tested on its own testing set
    S.retraining = 0.5;                   % [0, 1]; probabilistic retraining in each generation with the selected outputs
    S.forgetting_rate = 0.7;              % [0, 1]; weights are multiplied by 1-S.forgetting_rate before retraining
    S.fitness_measure = 'avg_score';    % choose from the fields of T - see in TestAttractor fn
    S.mutation_rate = 0;              % probability of mutation/bit during reproduction
    
    S.parametersets = zeros(1, S.popsize) + 1820122; % ID of the parameterset for the attractors
    S.popseeds = [1];
end

%% Parameters for testing individual networks

if S.mode == 'i'
    beeps = 3;
    S.folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\2. Modified Rolls model\';
    save2excel = 1;
    save_matfile = 1;
    save_plot = 1;
    
    S.popsize = 1;                    % should be 1 if trained_percentage=100
    S.fitness_measure = 'correlation';    % choose from the fields of T - see in TestAttractor fn
    S.parametersets = zeros(1, S.popsize) + 1820123; % ID of the parameterset for the attractors
    S.popseeds = [1];
    
    % Don't change these when testing individual networks!
    repetitions = 1;                   % should be 1
    S.forgetting_rate = 1;              % weights are multiplied by this number before each trainig session
    S.nbof_generations = 1;             % number of generations of attractor networks
    S.selection_type = 'truncation';    % 'truncation'
    S.selected_perc = 0;               % 0 to 100; the selected percentage of individuals for reproduction
    S.nbof_global_testingpatterns = 0;  % the number of global testing patterns; if 0 then each individual is tested on its own testing set
    S.retraining = 0;                   % 0 to 1; probabilistic retraining in each generation with the selected outputs
    S.mutation_rate = 0;                % probability of mutation/bit during reproduction
end

%% Run

tic
if numel(S.popseeds) < repetitions
    rng shuffle
    S.popseeds = randperm(repetitions*1000,repetitions);
end

for r = 1:repetitions
    r
    S.popseed = S.popseeds(r);
    [G, S] = AttractorPop(S);
    F(r,:) = nanmean(S.fitness, 1); % average fitness of the population in each generations; rows=repetitions; columns=generations
    
end

'Finished running';

%% Change fitness measure

if S.mode == 'i'
    performance = NaN(size(G,1), 3);
    for i = 1:numel(G)
        performance(i,1) = getfield(G{i}.T, 'correlation');
    end
    for i = 1:numel(G)
        performance(i,2) = getfield(G{i}.T, 'avg_score');
    end
    for i = 1:numel(G)
        performance(i,3) = getfield(G{i}.T, 'propof_correct');
    end
    S.avg_performance = mean(performance,1);
end
if S.mode == 's'
    S.avg_performance = NaN(1,3);
    avg_F = mean(F,1);
    if strcmp(S.fitness_measure, 'correlation')
        S.avg_performance(1) = avg_F(end);
    end
    if strcmp(S.fitness_measure, 'avg_score')
        S.avg_performance(2) = avg_F(end);
    end
    if strcmp(S.fitness_measure, 'propof_correct')
        S.avg_performance(3) = avg_F(end);
    end
end
'Changed fitness measure';

%% Save data

'Saving data...'

S.runningtime_min = toc/60;
if save_matfile == 1 % Save all variables in .mat file; later can be loaded
    save([S.folder, S.pop_ID, '.mat'], 'S', 'G', 'F', '-v7.3');
end

if save2excel
    excelfile = [S.folder, 'RESULTS.xlsx'];
    where = size(xlsread(excelfile),1)+1;
    P = getParameters(S.parametersets(1));
    tosave = {
        S.pop_ID,
        S.avg_performance(1),
        S.avg_performance(2),
        S.avg_performance(3),       
        S.mode,
        S.popsize,
        S.fitness_measure,
        S.parametersets,
        S.popseeds,
        repetitions,
        S.nbof_generations,
        S.selection_type,
        S.selected_perc,
        S.nbof_global_testingpatterns,
        S.retraining,
        S.forgetting_rate,
        S.mutation_rate,
        S.runningtime_min;
        P.inputseed,
        P.weightseed,
        P.trainingseed,
        func2str(P.weight_init),
        P.strenght_of_memory_traces,
        P.nbof_neurons,
        P.weight_deletion_mode,
        P.connection_density,
        func2str(P.activation_function),
        P.gain_factor,
        P.threshold,
        P.allow_selfloops,
        P.lengthof_patterns,
        P.nbof_patterns,
        P.sparseness,
        P.inactive_input,
        P.trained_percentage,
        P.learning_rule,
        P.learning_rate,
        P.forgetting_rate,
        P.autothreshold_aftertraining,
        func2str(P.threshold_algorithm),
        P.sparseness_difference,
        P.threshold_incr,
        P.threshold_setting_timeout,
        P.timeout,
        P.convergence_threshold,
        P.tolerance,
        P.synchronous_update,
        P.field_ratio,
        P.autothreshold_duringtesting,
        P.noise,
        P.missing_perc,
        };
    
    % Save summary of results to an excel file
    xlswrite(excelfile, tosave', 'results', ['A', num2str(where)]);
    
end

'Saved data'

%% Plot for 's' mode

if S.mode=='s' && save_plot == 1
    figure
    hold all
    for r = 1:repetitions
        plot(1:S.nbof_generations, F(r,:), 'LineWidth', 2)
        set(gca,'XTick', 1:S.nbof_generations)
    end
    xlabel('Generations')
    ylabel([{'Average fitness of the population'};{['(', S.fitness_measure,')']}])
    %set(gca, 'YLim', [-0.01,1.01])
    
    cim = S.pop_ID;
    title(cim)
    print('-dpng', [S.folder, cim, '.png'])
    close
end

%% Plot for 'i' mode

if S.mode=='i' && save_plot == 1
    if size(performance,1)>1
        boxplot(performance, 'labels', {'Correlation'; 'Proportion of correct neurons'; 'Proportion of correct patterns'})
        set(gca, 'YLim', [0,1])
        cim = S.pop_ID;
        title(cim)
        print('-dpng', [S.folder, cim, '.png'])
        close
    else
        plot(1:3, performance, 'b*')
        set(gca, 'XLim', [0.5,3.5])
        set(gca, 'XTick', [1 2 3], 'XTicklabel', {'Correlation', 'Proportion of correct neurons', 'Proportion of correct patterns'})
        set(gca, 'YLim', [0,1])
        cim = S.pop_ID;
        title(cim)
        print('-dpng', [S.folder, cim, '.png'])
        close
    end        
end

%% Monitor

%[S.runningtime_min, S.avg_performance, abs(sparseness(G{1}.D.trainingset) - sparseness(G{1}.T.outputs))]
%[avg_performance, G{1}.L.thresholds(1), sparseness(G{1}.D.trainingset), sparseness(G{1}.T.outputs), abs(sparseness(G{1}.D.trainingset) - sparseness(G{1}.T.outputs))]
% mean(S.fitness)
% %boxplot(S.fitness)
% %mutation_rate_pergeneration = 5*50*2*S.mutation_rate;
% S.pop_ID;
% sum(G{1}.T.outputs);

%% Visualize weights

if 1==0
    %figure
    %for i = 1:10
        imagesc(G{1}.W.state)
        %title(num2str(i))
    %end
    colorbar
    axis('square')
    %h = gca;
    %set(gca, 'XTick', 0.5:1:10.5)
    %set(gca, 'YTick', 0.5:1:10.5)
    %grid('on')
end

%% Beep
'Finished simulation'
for i = 1:beeps
    beep
    pause(0.5)
end
toc




