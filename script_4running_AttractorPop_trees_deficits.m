%% Load parameters

clear all

% folder = 'C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\';  % folder of functions
folder = '/mnt/am/Anna_dok/matlab/';              % folder of functions

%% Modify parameters

addpath(genpath(folder));
load([folder, 'params_trees_5.mat'])
% B.folder = [folder, 'RESULTS\7. Trees\deficits\'];              % folder for saving results
B.folder = [folder, 'deficits/'];   % folder for saving results

B.repetitions = 30;
B.save_movie = 0;
B.save_matfile = 0;
B.popseeds = B.repetitions+1 : B.repetitions*2; 
S.print2screen = 0;

%% Run

T.test_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
T.conditions = {'CC', 'MC', 'MR', 'RR'};
T.Bs = cell(1,4);

'Condition CC (Control condition)'
S.popsize = 100; 
S.mutation_rate = 0.03; 
S.retraining = 0.7;
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{1} = B;

'Condition MC (Memory Capacity; popsize / 10)'
S.popsize = 10; % S.selected_perc will be 10% instead of 3%!
S.mutation_rate = 0.03; 
S.retraining = 0.7;
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{2} = B;

'Condition MR (Mutation Rate * 10)'
S.popsize = 100; 
S.mutation_rate = 0.3; 
S.retraining = 0.7;
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{3} = B;

'Condition RR (Retraining Rate / 10)'
S.popsize = 100; 
S.mutation_rate = 0.03; 
S.retraining = 0.07;
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{4} = B;

%% Table: number of solvers

for b = 1:numel(T.Bs)
    T.nbof_solvers(b) = sum(T.Bs{b}.success);
end

solvers = cell(5,2);
solvers{2,1} = 'Control condition';
solvers{3,1} = 'Lower memory capacity';
solvers{4,1} = 'Higher mutation rate';
solvers{5,1} = 'Lower retraining probability ';
solvers{2,2} = T.nbof_solvers(1);
solvers{3,2} = T.nbof_solvers(2);
solvers{4,2} = T.nbof_solvers(3);
solvers{5,2} = T.nbof_solvers(4);
T.table_solvers = solvers;

%% Save test results

T
save([B.folder, 'test_', T.test_ID, '.mat'], '-v7.3');

for i = 1:3
    beep
    pause(0.5)
end











