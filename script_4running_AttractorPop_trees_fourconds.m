%% Load parameters

clear all

%folder = 'C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\';   % folder of functions
folder = '/mnt/am/Anna_dok/matlab/';               % folder of functions

%% Modify parameters

addpath(genpath(folder));
load([folder, 'params_trees_5.mat'])
%B.folder = [folder, 'RESULTS\7. Trees\fourconds\'];              % folder for saving results
B.folder = [folder, 'fourconds/'];   % folder for saving results

B.repetitions = 30;
B.save_movie = 0;
B.save_matfile = 0;
B.popseeds = 1:B.repetitions;   
S.print2screen = 0;

%% Run

T.test_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
T.conditions = {'2DD', '2DR', '3DD', '3DR'};
T.Bs = cell(1,4);

'Condition 2DD (2D + derived)'
P.sparseness_pretraining = [0.5, 0.5, 0];
P.sparseness_provoking =   [0.38, 0.5, 0];
[B,S,P,G] = run_AttractorPop_trees(B,S,P);
T.Bs{1} = B;

'Condition 2DR (2D + random)'
P.sparseness_pretraining = [0.5, 0.5, 0];
P.sparseness_provoking =   [0.5, 0.5, 0.5];
[B,S,P,G] = run_AttractorPop_trees(B,S,P);
T.Bs{2} = B;

'Condition 3DD (3D + derived)'
P.sparseness_pretraining = [0.5, 0.5, 0.5];
P.sparseness_provoking =   [0.38, 0.5, 0];
[B,S,P,G] = run_AttractorPop_trees(B,S,P);
T.Bs{3} = B;

'Condition 3DR (3D + random)'
P.sparseness_pretraining = [0.5, 0.5, 0.5];
P.sparseness_provoking =   [0.5, 0.5, 0.5];
[B,S,P,G] = run_AttractorPop_trees(B,S,P);
T.Bs{4} = B;

%% Table: number of solvers

for b = 1:numel(T.Bs)
    T.nbof_solvers(b) = sum(T.Bs{b}.success);
end

solvers = cell(3,3);
solvers{2,1} = '2D';
solvers{3,1} = 'random';
solvers{1,2} = 'derived';
solvers{1,3} = 'random';
solvers{2,2} = T.nbof_solvers(1);
solvers{2,3} = T.nbof_solvers(2);
solvers{3,2} = T.nbof_solvers(3);
solvers{3,3} = T.nbof_solvers(4);
T.table_solvers = solvers;

%% Save test results

T
save([B.folder, 'test_', T.test_ID, '.mat'], '-v7.3');

for i = 1:3
    beep
    pause(0.5)
end












