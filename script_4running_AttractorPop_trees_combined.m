%% Load parameters

clear all

folder = 'C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\';   % folder of functions
%folder = '/mnt/am/Anna_dok/matlab/';               % folder of functions

%% Modify parameters

addpath(genpath(folder));
load([folder, 'params_trees_5.mat'])
B.folder = [folder, 'RESULTS\7. Trees\combined\'];              % folder for saving results
%B.folder = [folder, 'combined/'];   % folder for saving results

B.repetitions = 30;
B.save_movie = 0;
B.save_matfile = 0;
B.popseeds = B.repetitions*2+1 : B.repetitions*3;   
S.print2screen = 0;

%% Run

T.test_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
T.conditions = {'CON', 'COM'}; % names
T.Bs = cell(1,2);

 %(15, 10, 0), (15, 90, 0), (84, 50, 0) and (38, 50, 65). 

% 'Control Condition'
'Control Condition'
P.sparseness_pretraining = [0.50, 0.50, 0.00;
                            0.50, 0.50, 0.00];
P.sparseness_provoking =   [0.38, 0.50, 0.00];
[B,S,P,G] = run_AttractorPop_trees(B,S,P);
T.Bs{1} = B;

% Combined condition
'Combined Condition'
P.sparseness_pretraining = [0.38, 0.50, 0.65;
                            0.50, 0.50, 0.00];
P.sparseness_provoking =   [0.38, 0.50, 0.65];
[B,S,P,G] = run_AttractorPop_trees(B,S,P);
T.Bs{2} = B;

%% Table: number of solvers

for b = 1:numel(T.Bs)
    T.nbof_solvers(b) = sum(T.Bs{b}.success);
end

solvers = cell(3,2);
solvers{2,1} = 'Control condition';
solvers{3,1} = 'Combined condition';
solvers{1,2} = 'Number of solvers';
solvers{2,2} = T.nbof_solvers(1);
solvers{3,2} = T.nbof_solvers(2);
T.table_solvers = solvers;

%% Save test results

T
save([B.folder, 'test_', T.test_ID, '.mat'], '-v7.3');

for i = 1:3
    beep
    pause(0.5)
end












