%% Load parameters

clear all
addpath(genpath('C:\Users\Anna\SkyDrive\Documents\MATLAB\'));
load('C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\params_trees_3.mat')

%% Modify parameters

B.folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\7. Trees\';
B.repetitions = 3;
B.save_movie = 0;
B.save_matfile = 0;
B.save_plot = 0;
S.save_pop = 1;
B.popseeds = [216];     % 704; random seed of independent runs

S.popsize = 10;%100                     % number of attractor networks in the population
S.nbof_generations = 50; %200            % maximum number of generations
S.selected_perc = 3;               % [0, 100]; the selected percentage of individuals for reproduction
S.mutation_rate = 0.03;
S.retraining = 0.7;
S.switchingprob_a=0.7;
S.switchingprob_b=0.03;
S.switchingprob_c=1;

P.nbof_pretrainingpatterns = 10;%90
P.pretraining = '2D';               % Method for generating the initial trainingset: 'random', '2D', 'fromtestingset'
P.initial_input = 'derived';        % Method for generating the initial testingset: 'random' or 'derived'

%% Run

[B,S,P,G] = run_AttractorPop_trees(B,S,P);

%% Calculate number of repetitions

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

if 1==0
as=[0.2, 0.4, 0.6]; % increasing as push doen the curve
bs=[0.05, 0.03, 0.01]; % decreasing bs push down the curve

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

cs=[0.5, 0.7, 0.9, 1];
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

a=0.7;
b=0.03;
c=1;
trial_dep = (1-(a.^(b.*generations)));
rep_dep = 1./(repetitions.^c);
switching_prob = rep_dep .* trial_dep;

figure
hold all
plot(generations, trial_dep)
plot(generations, rep_dep)
plot(generations, switching_prob)
legend('Trial dependent part', 'Repetition dependent part', 'Switching probability')
ylim([0, 1.01])
hold off

switching_prob(1:10)
end

%% To do










