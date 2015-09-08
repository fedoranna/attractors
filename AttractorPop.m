function [G, S] = AttractorPop(S)

%% Initialize population

tic
S.end_of_initializing_parameters = '--------';
S.pop_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');

% Seed
rng(S.popseed, 'twister');
seeds = randperm(S.popsize*30000, S.popsize*3);

% Set global problem (this will be the pattern against which each output is evaluated)
P = getParameters(S.parametersets(1));
if S.nbof_global_testingpatterns > 0
    S.global_problem = double(rand(S.nbof_global_testingpatterns, P.lengthof_patterns) <= P.sparseness);
    if P.inactive_input == -1
        S.global_problem = sign(S.global_problem-0.1);
    end
else S.global_problem = NaN;
end

% First generation
G = cell(S.popsize, S.nbof_generations); % each column is a generation
for i = 1:S.popsize
    P = getParameters(S.parametersets(i));
    %P = S.P;
    
    % Seeds
    P.inputseed = seeds(i);
    P.weightseed = seeds(i + S.popsize);
    P.trainingseed = seeds(i + S.popsize*2);
    
    % Initialize population
    A = InitializeAttractor(P);
    
    % Put the global problem (the solution) into one of the networks
    if S.known_global_problem && i == 1
        A.D.trainingset(1,:) = S.global_problem;
    end
    
    % Set global testing pattern
    if S.nbof_global_testingpatterns > 0
        A.D.testingset_O = S.global_problem;
        if S.firstgen_input_random
            A.D.testingset_I = double(rand(S.nbof_global_testingpatterns, P.lengthof_patterns) <= P.sparseness); % first generation gets random inputs
            if P.inactive_input == -1
                A.D.testingset_I = sign(A.D.testingset_I-0.1);
            end
        else
            A.D.testingset_I = A.D.trainingset(1:S.nbof_global_testingpatterns, :); % first generation gets input from their training patterns
        end
    end
    
    % Train and test the first generation
    A = TrainAttractor(A); % trainingset is the size of P.nbof_patterns
    A = TestAttractor(A);  % testingset is the size of S.nbof_global_testingpatterns
    G{i, 1} = A;
end
['Generation No. 1']

% Collecting fitness measures
S.correlation = NaN(S.popsize, S.nbof_generations);
S.avg_score = NaN(S.popsize, S.nbof_generations);
S.propof_correct = NaN(S.popsize, S.nbof_generations);
if S.nbof_generations == 1
    for i = 1:S.popsize        
        S.correlation(i, 1) = G{i, 1}.T.correlation;
        S.avg_score(i, 1) = G{i, 1}.T.avg_score;
        S.propof_correct(i, 1) = G{i, 1}.T.propof_correct;
    end
end

%% Evolution

S.nbof_selected = ceil(S.popsize * (S.selected_perc/100));
fitness = NaN(S.popsize, S.nbof_generations);

for g = 2:S.nbof_generations
    
    % Mutation before selection
    if S.mutation_rate > 0
        for i = 1:S.popsize
            mutationmatrix = double(rand(size(G{i, g-1}.T.outputs)) <= S.mutation_rate);
            if P.inactive_input == 0
                G{i, g-1}.T.outputs = abs(mutationmatrix - G{i, g-1}.T.outputs);
            end
            if P.inactive_input == -1
                mutationmatrix = sign(mutationmatrix - 0.1) * -1;
                G{i, g-1}.T.outputs = G{i, g-1}.T.outputs .* mutationmatrix;
            end
            
            G{i, g-1}.T.correctness = G{i, g-1}.T.outputs == G{i, g-1}.D.testingset_O;
            corr_matrix = corrcoef(G{i, g-1}.T.outputs, G{i, g-1}.D.testingset_O);
            G{i, g-1}.T.correlation = corr_matrix(1,2);                 % -1 to +1; correlation
            G{i, g-1}.T.scores = mean(G{i, g-1}.T.correctness, 2);      % 0 to 1; proportion of correct neurons for each testing pattern
            G{i, g-1}.T.avg_score = mean(G{i, g-1}.T.scores);           % 0 to 1; avg score on all testing patterns
            G{i, g-1}.T.avg_score_perc = mean(G{i, g-1}.T.scores)*100;  % 0 to 100; avg score percentage on all testing patterns
            G{i, g-1}.T.nbof_correct = sum(G{i, g-1}.T.scores == 1);    % 0 to P.nbof_patterns; nb of perfectly correct testing patterns
            G{i, g-1}.T.nbof_90perc_correct = sum(G{i, g-1}.T.scores > 0.9);
            G{i, g-1}.T.percof_correct = (G{i, g-1}.T.nbof_correct / size(G{i, g-1}.T.outputs, 1)) * 100; % 0 to 100; percentage of perfectly correct testing patterns
        end
    end
    
    % Collecting the fitness measure
    for i = 1:S.popsize        
        S.correlation(i, g-1) = G{i, g-1}.T.correlation;
        S.avg_score(i, g-1) = G{i, g-1}.T.avg_score;
        S.propof_correct(i, g-1) = G{i, g-1}.T.propof_correct;
        
        fitness(i,g-1) = getfield(G{i, g-1}.T, S.fitness_measure);
        if isnan(fitness(i,g-1))
            fitness(i,g-1) = 0;
        end
    end
    
    % Select the best output patterns
    if strcmp(S.selection_type, 'truncation')
        
        [x, index] =  sortrows(fitness, g-1); % ascending order
        
        i = 0;
        while fitness(index(numel(index)-S.nbof_selected+1-i)) == fitness(index(numel(index)-S.nbof_selected+1))
            startof_tie = numel(index) - S.nbof_selected + 1 - i;
            i = i+1;
        end
        selected = index(startof_tie : end);
        
        selected_outputs = cell(1,numel(selected));
        for i = 1:numel(selected)
            selected_outputs{i} = G{selected(i), g-1}.T.outputs;
        end
        
    end
    
    % "Reproduction": feeding back the selected outputs - retrain and test networks
    next = 1;
    for i = 1:S.popsize
        
        % Copy parent to next generation
        G{i, g} = G{i, g-1};
        
        % Modify
        G{i, g}.D.testingset_I = selected_outputs{next};
        G{i, g}.D.trainingset = selected_outputs{next};
        
        % Forget
        G{i, g}.W.state = G{i, g}.W.state * (1-S.forgetting_rate);
        
        % Train and test
        if rand < S.retraining
            G{i, g} = TrainAttractor(G{i, g});
        end
        G{i, g} = TestAttractor(G{i, g});
        
        next = next+1;
        if next > numel(selected_outputs)
            next = 1;
        end
        
        % Delete all but the last population to save memory
        if S.save_pop == 0
            G{i,g-1}=[];
        end
        
    end
    
    ['Generation No. ' num2str(g)]
    
end

%% Fitness of the last generation

% Mutation before selection
if S.mutation_rate > 0
    for i = 1:S.popsize
        mutationmatrix = double(rand(size(G{i, end}.T.outputs)) <= S.mutation_rate);
        if P.inactive_input == 0
            G{i, end}.T.outputs = abs(mutationmatrix - G{i, end}.T.outputs);
        end
        if P.inactive_input == -1
            mutationmatrix = sign(mutationmatrix - 0.1) * -1;
            G{i, end}.T.outputs = G{i, end}.T.outputs .* mutationmatrix;
        end
        
        G{i, end}.T.correctness = G{i, end}.T.outputs == G{i, end}.D.testingset_O;
        corr_matrix = corrcoef(G{i, end}.T.outputs, G{i, end}.D.testingset_O);
        G{i, end}.T.correlation = corr_matrix(1,2);                 % -1 to +1; correlation
        G{i, end}.T.scores = mean(G{i, end}.T.correctness, 2);      % 0 to 1; proportion of correct neurons for each testing pattern
        G{i, end}.T.avg_score = mean(G{i, end}.T.scores);           % 0 to 1; avg score on all testing patterns
        G{i, end}.T.avg_score_perc = mean(G{i, end}.T.scores)*100;  % 0 to 100; avg score percentage on all testing patterns
        G{i, end}.T.nbof_correct = sum(G{i, end}.T.scores == 1);    % 0 to P.nbof_patterns; nb of perfectly correct testing patterns
        G{i, end}.T.nbof_90perc_correct = sum(G{i, end}.T.scores > 0.9);
        G{i, end}.T.percof_correct = (G{i, end}.T.nbof_correct / size(G{i, end}.T.outputs, 1)) * 100; % 0 to 100; percentage of perfectly correct testing patterns
    end
end

% Collecting the fitness measure
for i = 1:S.popsize
    fitness(i,end) = getfield(G{i, end}.T, S.fitness_measure);
    if isnan(fitness(i,end))
        fitness(i,end) = 0;
    end
end

S.fitness = fitness;

S.popavg_correlation = nanmean(S.correlation,1);
S.popavg_avgscore = nanmean(S.avg_score,1);
S.popavg_propofcorrect = nanmean(S.propof_correct,1);

S.runningtime_min = toc/60;    








