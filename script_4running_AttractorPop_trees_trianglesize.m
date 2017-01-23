%% Load parameters

clear all

folder = 'C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\';   % folder of functions
%folder = '/mnt/am/Anna_dok/matlab/';               % folder of functions

%% Modify parameters

addpath(genpath(folder));
load([folder, 'params_trees_5.mat'])
B.folder = [folder, 'RESULTS\7. Trees\7. trianglesize\'];              % folder for saving results
%B.folder = [folder, 'combined/'];   % folder for saving results

B.repetitions = 3;
B.save_movie = 1;
B.save_matfile = 0;
B.popseeds = B.repetitions*2+1 : B.repetitions*3;   
S.print2screen = 1;

%% Run

mkdir(B.folder)
T.test_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
T.conditions = {'O', 'S', 'L'}; % names
T.Bs = cell(1,3); 

% Original
'Original size'
%P.side_tetrahedron = 80; 
%P.apex_tetrahedron = [15,10,0];
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{1} = B;

% Small
'Smaller size'
P.side_tetrahedron = 40; 
P.apex_tetrahedron = [15,10,0];
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{2} = B;

% Large
'Larger size'
P.side_tetrahedron = 90; 
P.apex_tetrahedron = [15,10,0];
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{3} = B;

%% Table: number of solvers

% for b = 1:numel(T.Bs)
%     T.nbof_solvers(b) = sum(T.Bs{b}.success);
% end
% 
% solvers = cell(3,2);
% solvers{2,1} = 'Control condition';
% solvers{3,1} = 'Combined condition';
% solvers{1,2} = 'Number of solvers';
% solvers{2,2} = T.nbof_solvers(1);
% solvers{3,2} = T.nbof_solvers(2);
% T.table_solvers = solvers;

%% Save test results

T
save([B.folder, 'test_', T.test_ID, '.mat'], '-v7.3');

for i = 1:3
    beep
    pause(0.5)
end












