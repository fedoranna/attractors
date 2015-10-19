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
    folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\7. Trees\';
    save2excel = 1;
    save_matfile = 1;
    save_plot = 1;
    make_movie = 1;
    
    B.repetitions = 1;                  % number of independent runs
    B.popseeds = [704];     % 704 random seed of independent runs
    
    S.nbof_generations = 200;             % number of generations of attractor networks
    S.popsize = 1000;                     % number of attractor networks in the population
    S.selection_type = 'elitist';    % 'truncation'
    S.selected_perc = 10;               % [0, 100]; the selected percentage of individuals for reproduction
    S.fitness_measure = 'fitness_side';    % choose from the fields of T - see in calculate_performance fn
    S.random_training_order = 1;
    S.random_testing_order = 1;
    S.mutation_rate = 0.003;              % probability of mutation/bit during reproduction
        
    S.retraining = 1;                   % [0, 1]; probabilistic retraining in each generation with the selected outputs
    S.nbof_global_testingpatterns = 0;
    S.known_global_problem = 0;         % 1: the global problem is used as the first trainingpattern of the first network in the population; 0: the global problem is unknown to all networks
    S.firstgen_input_random = 1;        % 1: the testing input of each network in the first generation is a subset of its trainingset; 0: the testing set is independent of the trainingset
    S.forgetting_rate = 0;              % [0, 1]; weights are multiplied by 1-S.forgetting_rate before retraining
    S.parametersets = zeros(1, S.popsize) + 20154; % name of the parameterset for the attractors
    S.save_pop = 0;                     % 1: save the whole population in G; 0: only save the last generation
    S.do_distance_test = 0;             % testonly works when S.nbof_global_tesingpatterns = 1
end

%% Parameters for testing individual networks

if S.mode == 'i'
    beeps = 3;
    folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\6. Selection_Storkey\';
    save2excel = 1;
    save_matfile = 1;
    save_plot = 1;
    
    B.repetitions = 2;                  % number of independent runs
    B.popseeds = [];                    % random seed of independent runs
    S.popsize = 10;                     % number of attractor networks in the population
    S.fitness_measure = 'avg_score';    % choose from the fields of T - see in TestAttractor fn
    S.parametersets = zeros(1, S.popsize) + 2015; % ID of the parameterset for the attractors
    
    % Don't change these when testing individual networks!
    S.forgetting_rate = 0;              % weights are multiplied by this number before each trainig session
    S.nbof_generations = 1;             % number of generations of attractor networks
    S.selection_type = 'truncation';    % 'truncation'
    S.selected_perc = 0;                % 0 to 100; the selected percentage of individuals for reproduction
    S.nbof_global_testingpatterns = 0;  % the number of global testing patterns; if 0 then each individual is tested on its own testing set
    S.retraining = 0;                   % 0 to 1; probabilistic retraining in each generation with the selected outputs
    S.forgetting_rate = 0;              % [0, 1]; weights are multiplied by 1-S.forgetting_rate before retraining
    S.mutation_rate = 0.000000025;                % probability of mutation/bit during reproduction
    S.known_global_problem = 0;         % 1: the global problem is used as the first trainingpattern of the first network in the population; 0: the global problem is unknown to all networks
    S.firstgen_input_random = 1;        % 1: the testing input of each network in the first generation is a subset of its trainingset; 0: the testing set is independent of the trainingset
    S.save_pop = 0;
  
end

%% Run

if numel(B.popseeds) < B.repetitions
    rng shuffle
    B.popseeds = randperm(B.repetitions*1000,B.repetitions);
end

B.tic = tic;
B.batch_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
pause(1)
B.fitness = NaN(B.repetitions, S.nbof_generations);
B.excelfile = [folder, 'RESULTS.xlsx'];
P = getParameters(S.parametersets(1));

for r = 1:B.repetitions
    
    %% Run simulations
    
    'Running...'
    r
    S.popseed = B.popseeds(r);
    [G, S] = AttractorPop_trees(S);
    B.fitness(r,:) = nanmean(S.fitness, 1); % average fitness of the population in each generations; rows=repetitions; columns=generations
    
    %% Save data
    
    'Saving data...'
    
    if save_matfile
        %save([folder, S.pop_ID, '.mat'], 'S', 'B', 'P', 'G', '-v7.3');
        save([folder, S.pop_ID, '.mat'], 'S', 'B', 'P', '-v7.3');
    end
    
    if save2excel
        collection = collect_parameters_trees(S,P);
        where = size(xlsread(B.excelfile),1)+1;
        xlswrite(B.excelfile, collection', 'results', ['A', num2str(where)]);        
    end
    
    %% Plotting
    
    'Plotting...'
    
    if S.mode=='s' && save_plot
        figure
        plot(1:S.nbof_generations, B.fitness(r,:), 'LineWidth', 2)
        %set(gca,'XTick', 1:S.nbof_generations)
        xlabel('Generations')
        ylabel([{'Average fitness of the population'};{'(average score)'}])
        set(gca, 'YLim', [0,1.01])
        
        cim = S.pop_ID;
        title(cim)
        print('-dpng', [folder, cim, '.png'])
        close        
    end    
    
    if make_movie
        moviemaker_trees(S,P,folder);
    end
    
    if S.mode == 'i' && save_plot
        performance = NaN(S.popsize, 3);
        performance(:,1) = S.correlation;
        performance(:,2) = S.avg_score;
        performance(:,3) = S.propof_correct;

        if size(performance,1)>1
            figure
            boxplot(performance, 'labels', {'Correlation'; 'Proportion of correct neurons'; 'Proportion of correct patterns'})
            set(gca, 'YLim', [0,1.1])
            cim = S.pop_ID;
            title(cim)
            print('-dpng', [folder, cim, '.png'])
            close
        else
            figure
            plot(1:3, performance, 'b*')
            set(gca, 'XLim', [0.5,3.5])
            set(gca, 'XTick', [1 2 3], 'XTicklabel', {'Correlation', 'Proportion of correct neurons', 'Proportion of correct patterns'})
            set(gca, 'YLim', [0,1.1])
            cim = S.pop_ID;
            title(cim)
            print('-dpng', [folder, cim, '.png'])
            close
        end
    end
    
end

%% Common plot for repetitions of 's' mode

'Printing common plot...'

if S.mode=='s' && save_plot && B.repetitions>1
    figure
    hold all
    for r = 1:B.repetitions
        plot(1:S.nbof_generations, B.fitness(r,:), 'LineWidth', 2)
        %set(gca,'XTick', 1:S.nbof_generations)
    end
    xlabel('Generations')
    ylabel([{'Average fitness of the population'};{'(average score)'}])
    set(gca, 'YLim', [0.4,1])
    
    cim = B.batch_ID;
    title(cim)
    print('-dpng', [folder, cim, '.png'])
    close
end

%% Monitor
% figure
%hist(S.closest_trained_pattern_indices(:), numel(unique(S.closest_trained_pattern_indices(:))))% figure
% boxplot(S.closest_trained_pattern_distances(:))

%numel(unique(S.fitness(:,end)))
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




