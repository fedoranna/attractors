clear all
addpath(genpath('C:\Matlab_functions\Attractor\'));

%% Parameters for demo

repetitions = 1;
beeps = 0;

S.popsize = 1;                    % number of attractor networks in the population
S.nbof_generations = 1;             % number of generations of attractor networks
S.selection_type = 'truncation';    % 'truncation'
S.selected_perc = 0;               % 0 to 100; the selected percentage of individuals for reproduction
S.nbof_global_testingpatterns = 0;  % the number of global testing patterns; if 0 then each individual is tested on its own testing set
S.retraining = 0;                   % 0 or 1; retraining in each generation with the selected outputs
S.fitness_measure = 'percof_correct';    % choose from the fields of T - see in TestAttractor fn

S.parametersets = zeros(1, S.popsize) + 81982; % ID of the parameterset for the attractors
S.popseeds = [];
felirat = {};
next = 1;

%% Run populations of Attractors

allscores = NaN(repetitions, S.nbof_generations);
if numel(S.popseeds) < repetitions
    rng shuffle
    S.popseeds = randperm(100,repetitions);
end

for r = 1:repetitions
    S.popseed = S.popseeds(r);
    [G, fitness] = AttractorPop(S);
    F(r,:) = mean(fitness); % average fitness of the population in each generations; rows=repetitions; columns=generations
end

figure
hold all
for r = 1:repetitions
    plot(1:S.nbof_generations, F(r,:), 'LineWidth', 2)
    %felirat(next) = {['retraining = ', num2str(S.retraining), '; changing testing patterns = ', num2str(S.change_testingset)]};
    %next=next+1;
    %legend(felirat, 'Location', 'SouthEast')
end
xlabel('Generations')
ylabel('Average fitness of the population (% of recalled patterns)')
%set(gca, 'YLim', [0,101])

%% Monitor

close
% ylabel('Average fitness of the population (closeness to solution)')
% set(gca, 'YLim', [0,1])
%figure
%plot(max(fitness))
%boxplot(fitness)
%mean(mean(G{end}.T.outputs))
%fitness'
%boxplot(F)
%G{1}.D.trainingset
%G{1}.T.outputs

mean(F)

imagesc(G{1}.W.state)
colorbar
axis('square')
h = gca;
set(gca, 'XTick', 0.5:1:10.5)
set(gca, 'YTick', 0.5:1:10.5)
grid('on')

%% Beep

for i = 1:beeps
    beep
    pause(0.5)
end




