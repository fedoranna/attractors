function [G, S] = AttractorPop(S)

%% Initialize population

S.pop_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');

% Seed
if strcmp(S.popseed, 'noseed')
else
    rng(S.popseed, 'twister');
    seeds = randperm(S.popsize*30000, S.popsize*3);
end

% Set global problem (this will be the pattern against which each output is evaluated)
P = getParameters(S.parametersets(1));
if S.nbof_global_testingpatterns > 0
    global_problem = double(rand(S.nbof_global_testingpatterns, P.lengthof_patterns) <= P.sparseness);
    S.global_problem = global_problem;
end

% First generation
G = cell(S.popsize, S.nbof_generations); % each column is a generation
for i = 1:S.popsize
    P = getParameters(S.parametersets(i));
    
    % Seeds
    if strcmp(S.popseed, 'noseed')
    else
        P.inputseed = seeds(i);
        P.weightseed = seeds(i*2);
        P.trainingseed = seeds(i*3);
    end
    
    % Initialize population
    A = InitializeAttractor(P);
    
    % Set global testing pattern
    if S.nbof_global_testingpatterns > 0
        A.D.testingset_O = global_problem;
        A.D.testingset_I = A.D.testingset_I(1:S.nbof_global_testingpatterns, :); % first generation gets random inputs for testing
    end
    
    % Train and test the first generation
    A = TrainAttractor(A); % trainingset is the size of P.nbof_patterns
    A = TestAttractor(A);  % testingset is the size of S.nbof_global_testingpatterns
    G{i, 1} = A;
end
['Generation No. 1']

%% Evolution

S.nbof_selected = ceil(S.popsize * (S.selected_perc/100));
fitness = NaN(S.popsize, S.nbof_generations);

for g = 2:S.nbof_generations
    
    % Mutation before selection               DO NOT DELETE
    if S.mutation_rate > 0
        for i = 1:S.popsize
            mutationmatrix = double(rand(size(G{i, g-1}.T.outputs)) <= S.mutation_rate);
            G{i, g-1}.T.outputs = abs(mutationmatrix - G{i, g-1}.T.outputs);
            
            G{i, g-1}.T.correctness = G{i, g-1}.T.outputs == G{i, g-1}.D.testingset_O;
            corr_matrix = corrcoef(G{i, g-1}.T.outputs, G{i, g-1}.D.testingset_O);
            G{i, g-1}.T.correlation = corr_matrix(1,2);
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
        fitness(i,g-1) = getfield(G{i, g-1}.T, S.fitness_measure);
    end
    
    % Select the best output patterns
    if strcmp(S.selection_type, 'truncation')
        
        [x, index] =  sortrows(fitness, g-1); % ascending order
        selected = index((end-S.nbof_selected+1) : end);
        
        selected_outputs = cell(1,numel(selected));
        for i = 1:numel(selected)
            selected_outputs{i} = G{selected(i), g-1}.T.outputs;
        end
        
    end
    
    %     % Mutation after selection
    %     if S.mutation_rate > 0
    %         for i = 1 : numel(selected_outputs)
    %             mutation_matrix = rand(size(selected_outputs{i}));
    %             for j = 1:numel(selected_outputs{i})
    %                 if mutation_matrix(j) < S.mutation_rate
    %                     selected_outputs{i}(j) = 1 - selected_outputs{i}(j);
    %                 end
    %             end
    %         end
    %     end
    
    % "Reproduction": feeding back the selected outputs - retrain and test networks
    next = 1;
    for i = 1:S.popsize
        
        % Copy parent to next generation
        G{i, g} = G{i, g-1};
        
        % Modify
        G{i, g}.D.testingset_I = selected_outputs{next};
        G{i, g}.D.trainingset = selected_outputs{next};
        
        % Forget
        if S.forgetting_rate ~= 1
            G{i, g}.W.state = G{i, g}.W.state * S.forgetting_rate;
        end
        
        % Train and test
        if S.retraining
            G{i, g} = TrainAttractor(G{i, g});
        end
        G{i, g} = TestAttractor(G{i, g});
        
        next = next+1;
        if next > numel(selected_outputs)
            next = 1;
        end
    end
    
    ['Generation No. ' num2str(g)]
    
end

%% Fitness of the last generation

for i = 1:S.popsize
    fitness(i,end) = getfield(G{i, end}.T, S.fitness_measure);
end
S.fitness = fitness;













