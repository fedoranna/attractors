%% Load parameters

clear all
addpath(genpath('C:\Users\Anna\SkyDrive\Documents\MATLAB\'));
load('C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\params_trees_3.mat')

%% Modify parameters

B.folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\7. Trees\';
B.repetitions = 1;
B.save_movie = 0;
B.save_matfile = 1;
B.save_plot = 1;
S.save_pop = 1;
B.popseeds = [659];     % 704; random seed of independent runs

S.popsize = 100;                     % number of attractor networks in the population
S.nbof_generations = 200;             % maximum number of generations
S.selected_perc = 3;               % [0, 100]; the selected percentage of individuals for reproduction
S.mutation_rate = 0.0003;
S.retraining = 0;

P.nbof_pretrainingpatterns = 90;
P.pretraining = '2D';               % Method for generating the initial trainingset: 'random', '2D', 'fromtestingset'
P.initial_input = 'derived';        % Method for generating the initial testingset: 'random' or 'derived'

P.synchronous_update = 1;           % 0/1; whether to use synchronous or asynchronous update when testing
P.update_each = 1;                  % update each neuron once, or update neurons wth replacement during asynchronous update

%% Run

[B,S,P,G] = run_AttractorPop_trees(B,S,P);

%% Plot retraining probability

generations = 1:S.nbof_used_generations;

for g = 1:S.nbof_used_generations
    reps = g - size(unique(S.best_position(1:g,:), 'rows'), 1);
    if reps == 0
        reps = 1;
    end
    repetitions(g) = reps;
end

repetitions

%% Trial dependent part

as=[0.1,0.2];
bs=[0.05, 0.07];

figure 
hold all
felirat = cell(numel(as)*numel(bs), 1);
for i = 1:numel(as)
    a = as(i);
    for j = 1:numel(bs)
        b = bs(j);
        trial_dep = (1-(a.^(b.*generations)));
        plot(generations, trial_dep)
        felirat{(i-1)*numel(bs)+j} = ['a=', num2str(a), ', b=', num2str(b)];       
    end
end
legend(felirat)

%% Repetition dependent part

cs=[0.5, 0.7, 0.9];
figure 
hold all
felirat = cell(numel(cs), 1);
for i = 1:numel(cs)
    c = cs(i);
    rep_dep = 1./(repetitions.^c);
    plot(generations, rep_dep)
    felirat{i} = ['c=', num2str(c)];       
end
legend(felirat)


%% Switching probability

a=0.2;
b=0.05;
c=0.9;
trial_dep = (1-(a.^(b.*generations)));
rep_dep = 1./(repetitions.^c);
switching_prob = rep_dep .* trial_dep;

figure
hold all
plot(generations, task_time)
plot(generations, rep_dep)
plot(generations, switching_prob)
legend('Trial dependent part', 'Repetition dependent part', 'Switching probability')
hold off

switching_prob(1:10)

%% To do


% try variance measure
% - write averaging plot for batch
% - write formula to calculate number of solvers from batch
% - experiment which parameters influence solution rate
% - try S.pretrain_solution
% - variability (variable sparseness) even in 2D previous experience should increase solution
% rate

%%









