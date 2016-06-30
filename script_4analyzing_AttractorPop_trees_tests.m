%% Paths

clear all
addpath(genpath('C:\Users\Anna\OneDrive\Documents\MATLAB\')); % path for the folder containing the functions
folder = 'C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\RESULTS\7. Trees\4. fourconds\'; % path for the folder containing the test file and for saving the results

%% Files and folders

cd(folder)
load(ls('test*'), 'B', 'T', 'S');
B.analysis_folder = folder;
B.excelfile = [B.analysis_folder, 'ANALYSIS.xlsx'];

%% Number of solvers

'Number of solvers'

% Chi2 test at the end
x1 = [];
x2 = [];
for b = 1:numel(T.Bs)
    x1 = [x1; repmat(T.conditions{b}(1:3), B.repetitions, 1)];
    x2 = [x2; repmat(1,T.nbof_solvers(b),1); repmat(2,B.repetitions-T.nbof_solvers(b),1)]; 
end    
[T.table_contingency, T.chi2stat, T.pval] = crosstab(x1,x2);
T.df = (size(T.table_contingency,1)-1) * (size(T.table_contingency,2)-1);

% Print chi2 test
T.table_solvers{1,1} = 'Number of solvers';
xlswrite(B.excelfile, T.table_solvers, 'solvers', 'A1');
where = size(xlsread(B.excelfile, 'solvers'),1)+2;
xlswrite(B.excelfile, T.table_contingency, 'solvers', ['A', num2str(where)]);
where = size(xlsread(B.excelfile, 'solvers'),1)+2;
xlswrite(B.excelfile, {'chi2', 'p', 'df'}, 'solvers', ['A', num2str(where)]);
xlswrite(B.excelfile, T.chi2stat, 'solvers', ['A', num2str(where+1)]);
xlswrite(B.excelfile, T.pval, 'solvers', ['B', num2str(where+1)]);
xlswrite(B.excelfile, T.df, 'solvers', ['C', num2str(where+1)]);

% Calculate number of solvers in each generation
for b = 1:numel(T.Bs)
    for g = 1:S.nbof_generations
        T.Bs{b}.nbof_solvers_at(g) = sum(T.Bs{b}.fitness_max(:,g)==1);
    end
end

% Plot number of solvers through generations
figure
hold all
felirat = cell(numel(T.Bs), 1);
for b = 1:numel(T.Bs)
    plot(T.Bs{b}.nbof_solvers_at)
    felirat{b} = T.conditions{b};
end
ylim([0,30.1])
xlabel('Generations')
ylabel('Number of solvers')
legend(felirat, 'Location', 'NorthWest')
print('-dpng', [B.analysis_folder, T.test_ID, '_nbof_solvers_through_generations', '.png'])
close

% When did the first solver solved it in the first group (that is supposed to be the control group)?
nonzeros = find(T.Bs{1}.nbof_solvers_at);
g = nonzeros(1);


% Chi2 test at generation g
T.nbof_solvers_at_gen = g;
for b = 1:numel(T.Bs)
    n(b) = sum(T.Bs{b}.nbof_solvers_at(g));
end
x2 = [];
for b = 1:numel(T.Bs)
    x2 = [x2; repmat(1,n(b),1); repmat(2,B.repetitions-n(b),1)]; 
end
[T.at_table_contingency,T.at_chi2stat,T.at_pval] = crosstab(x1,x2);

% Print chi2 test at generation g
xlswrite(B.excelfile, {['g = ', num2str(g)]}, 'solvers', 'J1')
xlswrite(B.excelfile, T.at_table_contingency, 'solvers', 'J2');
where = size(xlsread(B.excelfile, 'solvers'),1)+2;
xlswrite(B.excelfile, {'chi2', 'p', 'df'}, 'solvers', ['J', num2str(where)]);
xlswrite(B.excelfile, T.at_chi2stat, 'solvers', ['J', num2str(where+1)]);
xlswrite(B.excelfile, T.at_pval, 'solvers', ['K', num2str(where+1)]);
xlswrite(B.excelfile, T.df, 'solvers', ['L', num2str(where+1)]);

%% Time spent with task

'Time spent with task'

% Calculate
T.time = NaN(B.repetitions, numel(T.Bs));
for b = 1:numel(T.Bs)
    T.time(:,b) = T.Bs{b}.nbof_used_generations;
end

% Print
xlswrite(B.excelfile, T.conditions, 'tasktime', 'A1');
xlswrite(B.excelfile, T.time, 'tasktime', 'A2');

% Plot (notboxplot)
figure
notBoxPlot(T.time)
set(gca, 'XTickLabels', T.conditions)
ylabel('Time spent with task (number of generations)')
print('-dpng', [B.analysis_folder, T.test_ID, '_time_spent_notboxplot', '.png'])

% Plot (boxplot from ANOVA)
[ANOVA_p,ANOVA_table,ANOVA_stats] = anova1(T.time(:), x1, 'on');
ylabel('Time spent with task (generations)')
print('-dpng', [B.analysis_folder, T.test_ID, '_time_spent_boxplot', '.png'])
close
close
[ANOVA_c,ANOVA_m,ANOVA_h,ANOVA_nms] = multcompare(ANOVA_stats, 'display', 'on');
print('-dpng', [B.analysis_folder, T.test_ID, '_time_spent_intervals', '.png'])
close
ANOVA_table = [ANOVA_nms num2cell(ANOVA_m)];

%% Switch, length of selection and evolution

'Switch'

% Calculate
for b = 1:numel(T.Bs)
    for s = 1:B.repetitions
        T.Bs{b}.switch_at(s) = T.Bs{b}.Ss{s}.switch_at;
    end    
end
T.switch_at = NaN(B.repetitions, numel(T.Bs));
for b = 1:numel(T.Bs)
    for s = 1:B.repetitions
        T.switch_at(s,b) = T.Bs{b}.switch_at(s);
    end
end
T.lengthof_selection = T.switch_at - 1;
T.lengthof_evolution = T.time - T.switch_at + 1;
for i = 1:numel(T.switch_at)
    if isnan(T.switch_at(i))
        T.lengthof_selection(i) = T.time(i);
        T.lengthof_evolution(i) = 0;
    end
end

% Print
xlswrite(B.excelfile, {'Switch'}, 'switch', 'A1');
xlswrite(B.excelfile, T.switch_at, 'switch', 'A2');
where = size(xlsread(B.excelfile, 'switch'),1)+2;
xlswrite(B.excelfile, {'Length of selection'}, 'switch', ['A', num2str(where)]);
xlswrite(B.excelfile, T.lengthof_selection, 'switch', ['A', num2str(where+1)]);
where = size(xlsread(B.excelfile, 'switch'),1)+2;
xlswrite(B.excelfile, {'Length of evolution'}, 'switch', ['A', num2str(where)]);
xlswrite(B.excelfile, T.lengthof_evolution, 'switch', ['A', num2str(where+1)]);

% Plot 
figure
subplot(1,2,1)
boxplot(T.lengthof_selection, 'notch', 'on')
set(gca, 'xtick', 1:4, 'XTickLabel', T.conditions)
ylabel('Length of selection phase')
subplot(1,2,2)
boxplot(T.lengthof_evolution, 'notch', 'on')
set(gca, 'xtick', 1:4, 'XTickLabel', T.conditions)
ylabel('Length of evolution phase')
print('-dpng', [B.analysis_folder, T.test_ID, '_phases_boxplot', '.png'])
close

%% Plot: average best fitness

'Fitness'

figure
hold all
felirat = cell(numel(T.Bs), 1);
for b = 1:numel(T.Bs)
    plot(T.Bs{b}.avg_max_fitness)
    felirat{b} = T.conditions{b};
end
xlabel('Generations')
ylabel('Average best fitness')
legend(felirat)
print('-dpng', [B.analysis_folder, T.test_ID, '_average_best_fitness', '.png'])
close

%% Dimensions

for b = 1:numel(T.Bs)
    T.Bs{b}.dimensions = zeros(B.repetitions, S.nbof_generations)-1;
    for r = 1:numel(T.Bs{b}.Ss)
        T.Bs{b}.Ss{r}.twoD = T.Bs{b}.Ss{r}.best_position(1:T.Bs{b}.Ss{r}.nbof_used_generations, 3) < 1;
        T.Bs{b}.dimensions(r,1:T.Bs{b}.Ss{r}.nbof_used_generations) = T.Bs{b}.Ss{r}.twoD;
    end    
end

figure
for b = 1:numel(T.Bs)
    subplot(4,1,b)
    imagesc(T.Bs{b}.dimensions, [-1 1])
    title(['Condition ', T.conditions{b}])
    xlabel('Generations')
    ylabel('Individuals')
end
print('-dpng', [B.analysis_folder, T.test_ID, '_dimensions', '.png']) 
close

%% Number of repetitions

% Calculate
for b = 1:numel(T.Bs)
    for r = 1:numel(T.Bs{b}.Ss)
        T.Bs{b}.Ss{r}.repetitions = NaN(1,S.nbof_generations);
        for g = 1:T.Bs{b}.Ss{r}.nbof_used_generations
            T.Bs{b}.Ss{r}.repetitions(g) = g - size(unique(T.Bs{b}.Ss{r}.best_position(1:g,:), 'rows'), 1);
        end
        T.repetitions(r,b) = T.Bs{b}.Ss{r}.repetitions(g);
        if isnan(T.switch_at(r,b))
            T.repetitions_during_selection(r,b) = T.Bs{b}.Ss{r}.repetitions(g);
        else
            T.repetitions_during_selection(r,b) = T.Bs{b}.Ss{r}.repetitions(T.switch_at(r,b));
        end
    end
end

% Print
xlswrite(B.excelfile, T.repetitions, 'repetitions', 'A1');
where = size(xlsread(B.excelfile, 'repetitions'),1)+2;
xlswrite(B.excelfile, T.repetitions_during_selection, 'repetitions',['A', num2str(where)]);

% Plot
figure
boxplot(T.repetitions, 'notch', 'on')
set(gca, 'xtick', 1:4, 'XTickLabel', T.conditions)
ylabel('Number of repetitions')
print('-dpng', [B.analysis_folder, T.test_ID, '_repetitions', '.png']) 
close

figure
boxplot(T.repetitions_during_selection, 'notch', 'on')
set(gca, 'xtick', 1:4, 'XTickLabel', T.conditions)
ylabel('Number of repetitions during selection')
print('-dpng', [B.analysis_folder, T.test_ID, '_repetitions_during_selection', '.png']) 
close

%% Save test results

save([B.analysis_folder, 'test_', T.test_ID, '.mat'], '-v7.3');
T

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










