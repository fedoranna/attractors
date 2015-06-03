clear all
addpath(genpath('C:\Matlab_functions\Attractor\'));

mode = 's'; % selection or individuals
%% Parameters for selection

if mode == 's'
    beeps = 3;
    folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\';
    save2excel = 1;
    save_matfile = 1;
    
    repetitions = 1;
    S.popsize = 2;                    % number of attractor networks in the population
    S.nbof_generations = 2;             % number of generations of attractor networks
    S.selection_type = 'truncation';    % 'truncation'
    S.selected_perc = 20;               % 0 to 100; the selected percentage of individuals for reproduction
    S.nbof_global_testingpatterns = 1; % the number of global testing patterns; if 0 then each individual is tested on its own testing set
    S.retraining = 0;                   % 0 or 1; retraining in each generation with the selected outputs
    S.forgetting_rate = 1;              % weights are multiplied by this number before each trainig session
    S.fitness_measure = 'correlation';    % choose from the fields of T - see in TestAttractor fn
    S.mutation_rate = 0;              % probability of mutation/bit during reproduction
    
    S.parametersets = zeros(1, S.popsize) + 1820122; % ID of the parameterset for the attractors
    S.popseeds = [1:5];
end

%% Parameters for testing individual networks

if mode == 'i'
    beeps = 3;
    folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\';
    save2excel = 1;
    save_matfile = 1;
    
    S.popsize = 1;                    % should be 1 if trained_percentage=100
    S.fitness_measure = 'correlation';    % choose from the fields of T - see in TestAttractor fn
    S.parametersets = zeros(1, S.popsize) + 1820123; % ID of the parameterset for the attractors
    S.popseeds = [1];
    S.forgetting_rate = 1;              % weights are multiplied by this number before each trainig session
    
    % Don't change these when testing individual networks!
    repetitions = 1;                   % should be 1
    S.nbof_generations = 1;             % number of generations of attractor networks
    S.selection_type = 'truncation';    % 'truncation'
    S.selected_perc = 0;               % 0 to 100; the selected percentage of individuals for reproduction
    S.nbof_global_testingpatterns = 0;  % the number of global testing patterns; if 0 then each individual is tested on its own testing set
    S.retraining = 0;                   % 0 or 1; retraining in each generation with the selected outputs
    S.mutation_rate = 0;                % probability of mutation/bit during reproduction
end

%% Run

tic
if numel(S.popseeds) < repetitions
    rng shuffle
    S.popseeds = randperm(10000,repetitions);
end

for r = 1:repetitions
    S.popseed = S.popseeds(r);
    [G, S] = AttractorPop(S);
    F(r,:) = mean(S.fitness, 1); % average fitness of the population in each generations; rows=repetitions; columns=generations
end

%% Change fitness measure

if mode == 'i'
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
    avg_performance = mean(performance,1);
end
if mode == 's'
    avg_performance = NaN(1,3);
    avg_F = mean(F,1);
    if strcmp(S.fitness_measure, 'correlation')
        avg_performance(1) = avg_F(end);
    end
    if strcmp(S.fitness_measure, 'avg_score')
        avg_performance(2) = avg_F(end);
    end
    if strcmp(S.fitness_measure, 'propof_correct')
        avg_performance(3) = avg_F(end);
    end
end

%% Save data

S.runningtime_min = toc/60;
if save_matfile == 1 % Save all variables in .mat file; later can be loaded
    save([folder, S.pop_ID, '.mat'], '-v7.3');
end

if save2excel
    excelfile = [folder, 'RESULTS.xlsx'];
    where = size(xlsread(excelfile),1)+1;
    P = getParameters(S.parametersets(1));
    tosave = {
        S.pop_ID,
        avg_performance(1),
        avg_performance(2),
        avg_performance(3),       
        mode,
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
        S.mutation_rate,
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

%% Plot for 's' mode

if mode=='s'
    figure
    hold all
    for r = 1:repetitions
        plot(1:S.nbof_generations, F(r,:), 'LineWidth', 2)
    end
    xlabel('Generations')
    ylabel([{'Average fitness of the population'};{['(', S.fitness_measure,')']}])
    set(gca, 'YLim', [-0.01,1.01])
    
    cim = S.pop_ID;
    title(cim)
    print('-dpng', [folder, cim, '.png'])
    close
end

%% Plot for 'i' mode

if mode=='i'
    if size(performance,1)>1
        boxplot(performance, 'labels', {'Correlation'; 'Proportion of correct neurons'; 'Proportion of correct patterns'})
        set(gca, 'YLim', [0,1])
        cim = S.pop_ID;
        title(cim)
        print('-dpng', [folder, cim, '.png'])
        close
    else
        plot(1:3, performance, 'b*')
        set(gca, 'XLim', [0.5,3.5])
        set(gca, 'XTick', [1 2 3], 'XTicklabel', {'Correlation', 'Proportion of correct neurons', 'Proportion of correct patterns'})
        set(gca, 'YLim', [0,1])
        cim = S.pop_ID;
        title(cim)
        print('-dpng', [folder, cim, '.png'])
        close
    end        
end

%% Monitor

avg_performance
%mean(S.fitness)
%boxplot(S.fitness)
%mutation_rate_pergeneration = 5*50*2*S.mutation_rate;
S.pop_ID;
sum(G{1}.T.outputs);

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

for i = 1:beeps
    beep
    pause(0.5)
end
toc




