function [G, S] = AttractorPop_trees(S)

%% Initialize population

tic
S.end_of_initializing_parameters = '--------';
S.pop_ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');

% Seed
rng(S.popseed, 'twister');
seeds = randperm(S.popsize*30000, S.popsize*3);

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
    A = InitializeAttractor_trees(P);

    % Put the global problem (the solution) into the first network
    if S.known_global_problem==1 && i==1
        A.D.trainingset(1,:) = S.global_problem;
    end
    
    % Set global testing pattern and first input patterns if necessary
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
    A = TestAttractor_trees(A);  % testingset is the size of S.nbof_global_testingpatterns
    G{i, 1} = A;
    if S.do_distance_test 
        G{i, 1}.D.trained_patterns = G{i, 1}.D.trainingset;
        [G{i,1}.T.closest_trained_pattern_index, G{i,1}.T.closest_trained_pattern_distance] = distance_test(G{i,1}.T.outputs, G{i,1}.D.trained_patterns);
        S.closest_trained_pattern_indices(i,1) = G{i,1}.T.closest_trained_pattern_index;
        S.closest_trained_pattern_distances(i,1) = G{i,1}.T.closest_trained_pattern_distance;
    end
end

% Initializing fitness measures
S.best_positionD = NaN(S.nbof_generations,3);
S.fitness_activation = NaN(S.popsize, S.nbof_generations);
if S.nbof_generations == 1
    for i = 1:S.popsize
        S.fitness_activation = G{i, 1}.T.fitness_activation;
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
            
            G{i,g-1} = calculate_performance_trees(G{i,g-1});
        end
    end
    
    % Collecting the fitness measure
    for i = 1:S.popsize
        S.fitness_activation(i, g-1) = G{i, g-1}.T.fitness_activation;     
        fitness(i,g-1) = getfield(G{i, g-1}.T, S.fitness_measure);
        if isnan(fitness(i,g-1))
            fitness(i,g-1) = 0;
        end
    end
    
    % Select output patterns
    if strcmp(S.selection_type, 'elitist')
        
        [x, index] =  sortrows(fitness, g-1); % ascending order
        
        % The best S.nbof_selected outputs are selected (more, if there is a tie at the lower boundary)
        i = 0;
        while fitness(index(numel(index)-S.nbof_selected+1-i)) == fitness(index(numel(index)-S.nbof_selected+1))
            startof_tie = numel(index) - S.nbof_selected + 1 - i;
            i = i+1;
            if i==(numel(index)-S.nbof_selected+1)
                break
            end
        end
        selected = index(startof_tie : end);
        
        selected_outputs = cell(1,numel(selected));
        for i = 1:numel(selected)
            selected_outputs{i} = G{selected(i), g-1}.T.outputs; % the best output is the first
        end
        
        % Store best output
        best_output = G{index(end), g-1}.T.outputs;
        unit = numel(best_output)/3;
        x4 = sum(best_output(1:unit)==1);
        y4 = sum(best_output(unit+1:unit*2)==1);
        z4 = sum(best_output(unit*2+1:unit*3)==1);
        S.best_positionD(g-1,:) = [x4,y4,z4];
        
    end
    
    % "Reproduction": feeding back the selected outputs - retrain and test networks
    training_order = 1:numel(selected_outputs);
    testing_order = 1:numel(selected_outputs);
    if S.random_training_order
        training_order = randperm(numel(selected_outputs));
        testing_order = training_order;
    end
    if S.random_testing_order
        testing_order = randperm(numel(selected_outputs));
    end
    next = 1;
    for i = 1:S.popsize
        
        % Copy parent to next generation
        G{i, g} = G{i, g-1};
        
        % Modify
        G{i, g}.D.testingset_I = selected_outputs{testing_order(next)};
        G{i, g}.D.trainingset = selected_outputs{training_order(next)};
        
        % Forget
        G{i, g}.W.state = G{i, g}.W.state * (1-S.forgetting_rate);
        if S.do_distance_test && S.forgetting_rate
            G{i,g}.D.trained_patterns(:) = [];
        end
        
        % Train and test
        if rand < S.retraining
            G{i, g} = TrainAttractor(G{i, g});
            if S.do_distance_test 
                G{i, g}.D.trained_patterns = [G{i, g}.D.trained_patterns; G{i, g}.D.trainingset];
            end
        end
        G{i, g} = TestAttractor(G{i, g});
        if S.do_distance_test
            [G{i,g}.T.closest_trained_pattern_index, G{i,g}.T.closest_trained_pattern_distance] = distance_test(G{i,g}.T.outputs, G{i,g}.D.trained_patterns);
            S.closest_trained_pattern_indices(i,g) = G{i,g}.T.closest_trained_pattern_index;
            S.closest_trained_pattern_distances(i,g) = G{i,g}.T.closest_trained_pattern_distance;
        end
        
        next = next+1;
        if next > numel(selected_outputs)
            next = 1;
        end
        
        % Delete all but the last population to save memory
        if S.save_pop == 0
            G{i,g-1}=[];
        end
        
    end
    
    ['Generation No. ' num2str(g-1), ', Fitness = ', num2str(nanmean(fitness(:,g-1))), ' Pos: ', num2str(S.best_positionD(g-1,:)) ]%, ', N = ', num2str(numel(unique(fitness(:,g-1))))]
    
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
        
        G{i,end}=calculate_performance_trees(G{i,end});        
       
    end
end

% Collecting the fitness measure
for i = 1:S.popsize
    
    S.fitness_activation(i, end) = G{i, end}.T.fitness_activation;    
    fitness(i,end) = getfield(G{i, end}.T, S.fitness_measure);
    if isnan(fitness(i,end))
        fitness(i,end) = 0;
    end
    
end
if strcmp(S.selection_type, 'elitist')
        
        [x, index] =  sortrows(fitness, S.nbof_generations); % ascending order
        
        % Store best output
        best_output = G{index(end), end}.T.outputs;
        unit = numel(best_output)/3;
        x4 = sum(best_output(1:unit)==1);
        y4 = sum(best_output(unit+1:unit*2)==1);
        z4 = sum(best_output(unit*2+1:unit*3)==1);
        S.best_positionD(end,:) = [x4,y4,z4];
end

S.fitness = fitness;
S.popavg_fitness_activation = nanmean(S.fitness_activation,1);
S.runningtime_min = toc/60;








