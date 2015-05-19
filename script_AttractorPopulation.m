clear all
addpath(genpath('C:\Matlab_functions\Attractor\'));

mode = 'i'; % selection or individuals
%% Parameters for selection

if mode == 's'
    repetitions = 3;
    beeps = 3;

    S.popsize = 10;                    % number of attractor networks in the population
    S.nbof_generations = 50;             % number of generations of attractor networks
    S.selection_type = 'truncation';    % 'truncation'
    S.selected_perc = 20;               % 0 to 100; the selected percentage of individuals for reproduction
    S.nbof_global_testingpatterns = 5;  % the number of global testing patterns; if 0 then each individual is tested on its own testing set
    S.retraining = 1;                   % 0 or 1; retraining in each generation with the selected outputs
    S.fitness_measure = 'avg_score';    % choose from the fields of T - see in TestAttractor fn
    S.mutation_rate = 0;                % probability of mutation/bit during reproduction
    
    S.parametersets = zeros(1, S.popsize) + 1820122; % ID of the parameterset for the attractors
    S.popseeds = [1 2 3];
end

%% Parameters for testing individual networks

if mode == 'i'
    repetitions = 10;                   % this will be the number of tested networks
    beeps = 0;
    S.fitness_measure = 'correlation';    % choose from the fields of T - see in TestAttractor fn
    S.parametersets = zeros(1, S.popsize) + 182012; % ID of the parameterset for the attractors
    S.popseeds = [];
    
    % Don't change these when testing individual networks!
    S.popsize = 1;                    % should be 1 if trained_percentage=100
    S.nbof_generations = 1;             % number of generations of attractor networks
    S.selection_type = 'truncation';    % 'truncation'
    S.selected_perc = 0;               % 0 to 100; the selected percentage of individuals for reproduction
    S.nbof_global_testingpatterns = 0;  % the number of global testing patterns; if 0 then each individual is tested on its own testing set
    S.retraining = 0;                   % 0 or 1; retraining in each generation with the selected outputs
    S.mutation_rate = 0;                % probability of mutation/bit during reproduction
        
end

%% Run

S.pop_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
allscores = NaN(repetitions, S.nbof_generations);
if numel(S.popseeds) < repetitions
    rng shuffle
    S.popseeds = randperm(100,repetitions);
end

for r = 1:repetitions
    S.popseed = S.popseeds(r);
    [G, S] = AttractorPop(S);
    F(r,:) = mean(S.fitness, 1); % average fitness of the population in each generations; rows=repetitions; columns=generations
end

%% Plot

if mode=='s'
    figure
    hold all
    for r = 1:repetitions
        plot(1:S.nbof_generations, F(r,:), 'LineWidth', 2)
    end
    xlabel('Generations')
    ylabel([{'Average fitness of the population'};{'(proportion of correctly recalled output bits)'}])
    set(gca, 'YLim', [0.5,1.0])

    cim = ['Synchronous update, m=', num2str(S.mutation_rate)];
    title(cim)
    print('-dpng', ['C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\', cim, '.png'])
    close
end

if mode=='i'
    boxplot(F)
    cim = ['Pop. ', S.pop_ID];
    title(cim)
    print('-dpng', ['C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\', cim, '.png'])
    close
end

%% Monitor

S.fitness;
%boxplot(S.fitness)
F
mutation_rate_pergeneration = 5*50*2*S.mutation_rate;

%% Visualize weights

% imagesc(G{1}.W.state)
% colorbar
% axis('square')
% h = gca;
% set(gca, 'XTick', 0.5:1:10.5)
% set(gca, 'YTick', 0.5:1:10.5)
% grid('on')

%% Beep

for i = 1:beeps
    beep
    pause(0.5)
end




