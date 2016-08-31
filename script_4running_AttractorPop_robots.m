%% Load parameters

clear all

folder = 'C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\';   % folder of functions
%folder = '/mnt/am/Anna_dok/matlab/';               % folder of functions

%% Modify parameters

addpath(genpath(folder));
load([folder, 'params_robots_1.mat'])
B.folder = [folder, 'RESULTS\8. Robots\'];              % folder for saving results
%B.folder = [folder, 'combined/'];   % folder for saving results

B.repetitions = 10;
B.save_movie = 0;
B.save_matfile = 0;
B.popseeds = B.repetitions*2+1 : B.repetitions*3;   
S.print2screen = 1;

S.nbof_generations = 200;
S.popsize = 100;    
%% Run

mkdir(B.folder)
T.test_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
T.conditions = {'CO1', 'CO2'}; % names
T.Bs = cell(1,2); 

% 'Condition 1'
'Condition 1'
[B,S,P,G] = run_AttractorPop_robots(B,S,P);
T.Bs{1} = B;

% 'Condition 2'
'Condition 2'
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
save([B.folder, 'test_', T.test_ID, '.mat'], '-v7.3');

for i = 1:3
    beep
    pause(0.5)
end












