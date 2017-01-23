%% Load parameters

clear all
addpath(genpath('C:\Users\Anna\OneDrive\Documents\MATLAB\'));
load('C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\params_trees_4.mat')
B.folder = 'C:\Users\Anna\Documents\RESULTS-Trees\';

% addpath(genpath('/mnt/am/Anna_dok/matlab/'));
% load('/mnt/am/Anna_dok/matlab/params_trees_4.mat');
% B.folder = '/mnt/am/Anna_dok/matlab/RESULTS/deficits/';

%% Modify parameters

B.beeps = 0;
B.repetitions = 30;
B.save_movie = 0;
B.save_matfile = 0;
B.save_plot = 1;
B.save2excel = 0;
S.save_pop = 0;
B.popseeds = B.repetitions+1 : B.repetitions*2;     % 704; random seed of independent runs
P.sparseness_pretraining = [0.5, 0.5, 0];
P.sparseness_provoking =   [0.38, 0.5, 0];
S.nbof_generations = 100;            % maximum number of generations

% Not likely
% P.nbof_pretrainingpatterns = 90;
% P.learning_rate = 1;
% P.forgetting_rate = 0.1;
% P.timeout = 33;
% P.connection_density = 1;
% S.selected_perc = 3;

% Likely
% S.popsize = 100; 
% S.mutation_rate = 0.03; 
% S.retraining = 0.7;

%% Run

T.test_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
T.Bs = cell(1,4);

S.popsize = 100; 
S.mutation_rate = 0.03; 
S.retraining = 0.7;
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{1} = B;

S.popsize = 20; 
S.mutation_rate = 0.03; 
S.retraining = 0.7;
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{2} = B;

S.popsize = 100; 
S.mutation_rate = 0.3; 
S.retraining = 0.7;
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{3} = B;

S.popsize = 100; 
S.mutation_rate = 0.03; 
S.retraining = 0.2;
[B,S,P,G] = run_AttractorPop(B,S,P);
T.Bs{4} = B;

%% Chi-square test

n1 = sum(T.Bs{1}.success);
n2 = sum(T.Bs{2}.success);
n3 = sum(T.Bs{3}.success);
n4 = sum(T.Bs{4}.success);
N1 = B.repetitions;
N2 = B.repetitions;
N3 = B.repetitions;
N4 = B.repetitions;

x1 = [repmat('a',N1,1); repmat('b',N2,1); repmat('c',N3,1); repmat('d',N4,1)];
x2 = [repmat(1,n1,1); repmat(2,N1-n1,1); 
    repmat(1,n2,1); repmat(2,N2-n2,1);
    repmat(1,n3,1); repmat(2,N3-n3,1);
    repmat(1,n4,1); repmat(2,N4-n4,1)];

[T.table_contingency,T.chi2stat,T.pval] = crosstab(x1,x2);
T.df = (size(T.table_contingency,1)-1) * (size(T.table_contingency,2)-1);

%% Table: number of solvers

solvers = cell(5,2);
solvers{2,1} = 'control';
solvers{3,1} = 'popsize';
solvers{4,1} = 'mutation';
solvers{5,1} = 'retraining';
solvers{2,2} = n1;
solvers{3,2} = n2;
solvers{4,2} = n3;
solvers{5,2} = n4;
T.table_solvers = solvers;

%% Plot

figure
bar([n1,n2,n3,n4])

figure
hold all
plot(T.Bs{1}.avg_max_fitness)
plot(T.Bs{2}.avg_max_fitness)
plot(T.Bs{3}.avg_max_fitness)
plot(T.Bs{4}.avg_max_fitness)

T

%% Solution time

time = NaN(B.repetitions, numel(T.Bs));
for i = 1:numel(T.Bs)
    time(:,i) = T.Bs{i}.nbof_used_generations;
end
time

%% ANOVA

time_column = time(:);
group_column = [repmat('c', B.repetitions, 1); 
    repmat('p', B.repetitions, 1);
    repmat('m', B.repetitions, 1);
    repmat('r', B.repetitions, 1)]

[p,t,st] = anova1(time_column, group_column, 'on')
[c,m,h,nms] = multcompare(st, 'display', 'on')
[nms num2cell(m)]

%% Save test results

save([B.folder, 'test_', T.test_ID, '.mat'], '-v7.3');

for i = 1:3
    beep
    pause(0.5)
end

%% To do

% - inverzet kizárni
% - try back and forth switch
% - write script for comparing different populations
% - experiment which parameters influence solution rate
% - try S.pretrain_solution
% - variability (variable sparseness) even in 2D previous experience should increase solution rate
% - 2D pretraining with more patterns should decrease success, 3D
% pretraining with more patterns should increase success








