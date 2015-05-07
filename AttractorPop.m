function [G, fitness] = AttractorPop(S)

%% Initialize population

% Seed
if strcmp(S.popseed, 'noseed')    
else
    rng(S.popseed, 'twister');
    seeds = randperm(S.popsize*3, S.popsize*3);
end

% Set global problem (this will be the pattern against which each output is evaluated)
P = getParameters(S.parametersets(1));
if S.nbof_global_testingpatterns > 0
    global_problem = double(rand(S.nbof_global_testingpatterns, P.lengthof_patterns) <= P.sparseness);
end

% First generation
G = cell(S.popsize, S.nbof_generations); % each column is a generation
for i = 1:S.popsize
    P = getParameters(S.parametersets(i));
    
    % Seeds
    if strcmp(S.popseed, 'noseed')    
    else
        P.inputseed = seeds(1);
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
    A = TrainAttractor(A);
    A = TestAttractor(A);
    G{i, 1} = A;
end
['Generation No. 1']

%% Evolution

S.nbof_selected = round(S.popsize * (S.selected_perc/100));
fitness = NaN(S.popsize, S.nbof_generations);

for g = 2:S.nbof_generations
    
    % Collecting the fitness measure    
    for i = 1:S.popsize
        fitness(i,g-1) = getfield(G{i, g-1}.T, S.fitness_measure);
    end
    
    % Selection    
    if strcmp(S.selection_type, 'truncation')
        
        [x, index] =  sortrows(fitness, g-1); % ascending order        
        selected = index((end-S.nbof_selected+1) : end);
        
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
    fitness(i,end) = getfield(G{i, g-1}.T, S.fitness_measure);
end













