%% Load parameters

clear all
addpath(genpath('C:\Users\Anna\SkyDrive\Documents\MATLAB\'));
load('C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\7. Trees\Jumping\params_trees_1.mat')

%% Modify parameters

B.folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\7. Trees\Jumping\';
B.repetitions = 1;
B.save_movie = 1;
B.save_matfile = 1;
B.save_plot = 1;
S.save_pop = 1;
B.popseeds = [659];     % 704; random seed of independent runs
 
S.popsize = 100;                     % number of attractor networks in the population
S.nbof_generations = 20;             % maximum number of generations
S.selected_perc = 3;               % [0, 100]; the selected percentage of individuals for reproduction
S.mutation_rate = 0;
S.retraining = 0.7;
P.stopping_fitness = 1;
S.fitness_measure = 'fitness_position';
S.random_training_order=1;
S.random_testing_order=1;
 
P.learning_rate = 1;
P.forgetting_rate = 0;
P.pretraining = '2D';               % Method for generating the initial trainingset: 'random', '2D', 'fromtestingset'
P.initial_input = 'derived';        % Method for generating the initial testingset: 'random' or 'derived'
P.weight_init = @zeros;
P.strenght_of_memory_traces = 0;
P.threshold = 0;
 
P.nbof_pretrainingpatterns = 90;
 
P.learning_rule = 'Storkey_bypattern';
P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
P.update_each = 0;                  % update each neuron once, or update neurons wth replacement during asynchronous update
 
P.timeout = 30;

%% New parameters

S.switchingprob_a=0.7;
S.switchingprob_b=0.03;
S.switchingprob_c=1;
S.stopping_fitness = 1;

%% Figure of weight matrices

if 1==0
P.learning_rule = 'Storkey';
[B,S,P,G] = run_AttractorPop(B,S,P);

figure
subplot(3,2,1)
imagesc(G{1}.W.state)
axis square
colorbar

subplot(3,2,3)
imagesc(G{2}.W.state)
axis square
colorbar

subplot(3,2,5)
imagesc(G{3}.W.state)
axis square
colorbar

P.learning_rule = 'Storkey_bypattern';
[B,S,P,G] = run_AttractorPop(B,S,P);

subplot(3,2,2)
imagesc(G{1}.W.state)
axis square
colorbar

subplot(3,2,4)
imagesc(G{2}.W.state)
axis square
colorbar

subplot(3,2,6)
imagesc(G{3}.W.state)
axis square
colorbar
end

%% Figure of patterns

if 1==0
figure

P.learning_rule = 'Storkey';
P.synchronous_update = 1;           % 0/1; whether to use synchronous or asynchronous update when testing
P.update_each = 1;                  % update each neuron once, or update neurons wth replacement during asynchronous update
[B,S,P,G] = run_AttractorPop(B,S,P);
subplot(3,2,1)
imagesc([G{1}.D.trainingset; G{1}.D.testingset_I; G{2}.D.trainingset; G{2}.D.testingset_I; G{3}.D.trainingset])

P.learning_rule = 'Storkey';
P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
P.update_each = 1;                  % update each neuron once, or update neurons wth replacement during asynchronous update
[B,S,P,G] = run_AttractorPop(B,S,P);
subplot(3,2,3)
imagesc([G{1}.D.trainingset; G{1}.D.testingset_I; G{2}.D.trainingset; G{2}.D.testingset_I; G{3}.D.trainingset])

P.learning_rule = 'Storkey';
P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
P.update_each = 0;                  % update each neuron once, or update neurons wth replacement during asynchronous update
[B,S,P,G] = run_AttractorPop(B,S,P);
subplot(3,2,5)
imagesc([G{1}.D.trainingset; G{1}.D.testingset_I; G{2}.D.trainingset; G{2}.D.testingset_I; G{3}.D.trainingset])

P.learning_rule = 'Storkey_bypattern';
P.synchronous_update = 1;           % 0/1; whether to use synchronous or asynchronous update when testing
P.update_each = 1;                  % update each neuron once, or update neurons wth replacement during asynchronous update
[B,S,P,G] = run_AttractorPop(B,S,P);
subplot(3,2,2)
imagesc([G{1}.D.trainingset; G{1}.D.testingset_I; G{2}.D.trainingset; G{2}.D.testingset_I; G{3}.D.trainingset])

P.learning_rule = 'Storkey_bypattern';
P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
P.update_each = 1;                  % update each neuron once, or update neurons wth replacement during asynchronous update
[B,S,P,G] = run_AttractorPop(B,S,P);
subplot(3,2,4)
imagesc([G{1}.D.trainingset; G{1}.D.testingset_I; G{2}.D.trainingset; G{2}.D.testingset_I; G{3}.D.trainingset])

P.learning_rule = 'Storkey_bypattern';
P.synchronous_update = 0;           % 0/1; whether to use synchronous or asynchronous update when testing
P.update_each = 0;                  % update each neuron once, or update neurons wth replacement during asynchronous update
[B,S,P,G] = run_AttractorPop(B,S,P);
subplot(3,2,6)
imagesc([G{1}.D.trainingset; G{1}.D.testingset_I; G{2}.D.trainingset; G{2}.D.testingset_I; G{3}.D.trainingset])

end

%% Test

[B,S,P,G] = run_AttractorPop(B,S,P);










