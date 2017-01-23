% This function runs evolution of patterns in a population of
% attractor networks

function [B,S,P,G] = run_AttractorPop(B,S,P)

%% Fill in task specific parameters

S.parametercollector = str2func(['collect_parameters_', S.task]);
S.moviemaker = str2func(['moviemaker_', S.task]);
S.switchingprob_calculator = str2func(['switchingprob_', S.task]);
P.testingsetgenerator = str2func(['generate_testingset_', S.task]);
P.trainingsetgenerator = str2func(['generate_trainingset_', S.task]);
P.performancecalculator = str2func(['calculate_performance_', S.task]);

%% Run

if numel(B.popseeds) < B.repetitions
    rng shuffle
    B.popseeds = randperm(B.repetitions*1000,B.repetitions);
end

B.endof_initializing_parameters = '-----------------------------';
B.tic = tic;
B.batch_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
pause(1)
B.excelfile = [B.folder, 'RESULTS.xlsx'];

B.Ss = cell(1,B.repetitions);
B.fitness_avg = NaN(B.repetitions, S.nbof_generations);
B.fitness_max = NaN(B.repetitions, S.nbof_generations);
B.avg_max_fitness = NaN(B.repetitions, S.nbof_generations);
B.nbof_used_generations = NaN(B.repetitions,1);
B.last_best_position = NaN(B.repetitions,P.lengthof_position);
B.success = NaN(B.repetitions,1);
B.switch_at = NaN(B.repetitions,1);

for r = 1:B.repetitions
    
    %% Run simulations
    
    if S.print2screen
        'Running...'
    end
    r
    S.popseed = B.popseeds(r);
    [G, S] = AttractorPop_general(P, S);
    
    % Save batch results in B
    B.Ss{r} = S;
    B.fitness_avg(r,:) = nanmean(S.fitness, 1); % average fitness of the population in each generations; rows=repetitions; columns=generations
    B.fitness_max(r,:) = max(S.fitness, [], 1); % maximum fitness of the population in each generations; rows=repetitions; columns=generations
    for i=1:numel(B.fitness_max)
        if isnan(B.fitness_max(i))
            B.fitness_max(i) = 1;
        end
    end    
    B.avg_max_fitness = nanmean(B.fitness_max, 1);
    B.nbof_used_generations(r) = S.nbof_used_generations;
    B.last_best_position(r,:) = S.best_position(S.nbof_used_generations,:);
    B.success(r) = S.success;
    B.switch_at(r) = S.switch_at;   
    
    %% Save data
    
    if S.print2screen
        'Saving data...'
    end
    
    if B.save_matfile
        %save([B.folder, S.pop_ID, '.mat'], 'S', 'B', 'P', 'G', '-v7.3');
        save([B.folder, S.pop_ID, '.mat'], 'S', 'B', 'P', '-v7.3');
    end
    
    if B.save2excel
        collection = S.parametercollector(S,P);
        where = size(xlsread(B.excelfile),1)+1;
        xlswrite(B.excelfile, collection', 'results', ['A', num2str(where)]);
    end
    
    %% Plotting
    
    if S.print2screen
        'Plotting...'
    end
    
    if B.save_plot
        figure
        hold all
        plot(1:S.nbof_used_generations, B.fitness_avg(r,1:S.nbof_used_generations), 'LineWidth', 2)
        plot(1:S.nbof_used_generations, B.fitness_max(r,1:S.nbof_used_generations), 'LineWidth', 2)
        plot([S.switch_at,S.switch_at],[0,1])
        %set(gca,'XTick', 1:S.nbof_used_generations)
        xlabel('Generations')
        ylabel('Average and maximum fitness of the population')
        set(gca, 'YLim', [0,1.01])
        
        cim = S.pop_ID;
        title(cim)
        print('-dpng', [B.folder, cim, '.png'])
        close
    end
    
    if B.save_movie
        S.moviemaker(S,P,B.folder);
    end
    
end

save([B.folder, 'batch_', B.batch_ID, '.mat'], 'B', 'S', 'P', '-v7.3');

%% Beep

if S.print2screen
    'Finished batch simulation'
end
for i = 1:B.beeps
    beep
    pause(0.5)
end
B.toc = toc;

%%
