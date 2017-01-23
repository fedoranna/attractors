%% Load parameters

clear all

folder = 'C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\';   % folder of functions
%folder = '/mnt/am/Anna_dok/matlab/';               % folder of functions

%% Modify parameters

addpath(genpath(folder));
load([folder, 'params_robots_2.mat'])
B.folder = [folder, 'RESULTS\8. Robots\'];              % folder for saving results
%B.folder = [folder, 'combined/'];   % folder for saving results

B.save_matfile = 0; % Save individual simulations
B.popseeds = B.repetitions*2+1 : B.repetitions*3;   
S.print2screen = 1;

B.repetitions = 3; % Number of individuals/simulations in a condition
S.nbof_generations = 2; % Number of gnerations during selection/evolution; Time out for a single simulation for solving the task
S.popsize = 10;  % Number of attractor networks within an individual

%% Run

mkdir(B.folder)
T.test_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
T.conditions = {'MAX', 'MIN'}; % names
T.Bs = cell(1,2); 

% 'Condition 1'
'Condition 1'
S.fitness_measure = 'fitness_maximize';
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{1} = B;

% 'Condition 2'
'Condition 2'
S.fitness_measure = 'fitness_minimize';
[B,S,P,G] = run_AttractorPop_robots(B,S,P);
T.Bs{2} = B;

%% Table: number of solvers

for b = 1:numel(T.Bs)
    T.nbof_solvers(b) = sum(T.Bs{b}.success);
end

solvers = cell(3,2);
solvers{2,1} = 'Condition 1';
solvers{3,1} = 'Condition 2';
solvers{1,2} = 'Number of solvers';
solvers{2,2} = T.nbof_solvers(1);
solvers{3,2} = T.nbof_solvers(2);
T.table_solvers = solvers;

%% Save test results

T
save([B.folder, 'test_', T.test_ID, '.mat'], 'B', '-v7.3');

for i = 1:3
    beep
    pause(0.5)
end

%% Test

figure
subplot(3,2,1)
imagesc(T.Bs{1}.Ss{1}.best_output) % there should be 50-50 bands of red and blue
subplot(3,2,2)
imagesc(T.Bs{2}.Ss{1}.best_output) % there should be 50-50 bands of red and blue
subplot(3,2,3)
imagesc(T.Bs{1}.Ss{2}.best_output) % there should be 50-50 bands of red and blue
subplot(3,2,4)
imagesc(T.Bs{2}.Ss{2}.best_output) % there should be 50-50 bands of red and blue
subplot(3,2,5)
imagesc(T.Bs{1}.Ss{3}.best_output) % there should be 50-50 bands of red and blue
subplot(3,2,6)
imagesc(T.Bs{2}.Ss{3}.best_output) % there should be 50-50 bands of red and blue

%%
figure
subplot(3,2,1)
imagesc(T.Bs{1}.Ss{1}.best_position, [-50,+50]) % all of it should be 50 for best fitness
subplot(3,2,2)
imagesc(T.Bs{2}.Ss{1}.best_position, [-50,+50]) % all of it should be 50 for best fitness
subplot(3,2,3)
imagesc(T.Bs{1}.Ss{2}.best_position, [-50,+50]) % all of it should be 50 for best fitness
subplot(3,2,4)
imagesc(T.Bs{2}.Ss{2}.best_position, [-50,+50]) % all of it should be 50 for best fitness
subplot(3,2,5)
imagesc(T.Bs{1}.Ss{3}.best_position, [-50,+50]) % all of it should be 50 for best fitness
subplot(3,2,6)
imagesc(T.Bs{2}.Ss{3}.best_position, [-50,+50]) % all of it should be 50 for best fitness










