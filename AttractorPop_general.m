function [G, S] = AttractorPop_general(P, S)

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
    
    % Seeds
    P.inputseed = seeds(i);
    P.weightseed = seeds(i + S.popsize);
    P.trainingseed = seeds(i + S.popsize*2);
    
    % Initialize population
    A = InitializeAttractor_general(P);
    
    % Put the solution into the first network if necessary
    if S.pretrain_solution==1 && i==1
        A.D.trainingset(1,:) = S.solution;
    end
    
    % Train and test the first generation
    A = TrainAttractor(A); % trainingset is the size of P.nbof_patterns
    A = TestAttractor_general(A);  % testingset is the size of S.nbof_testingpatterns
    
    % Store network in G
    G{i, 1} = A;
    
end

%% Evolution

S.nbof_selected = ceil(S.popsize * (S.selected_perc/100));
S.fitness = NaN(S.popsize, S.nbof_generations);
S.indexof_best = NaN(S.nbof_generations,1);
S.best_output = NaN(S.nbof_generations, P.lengthof_patterns);
S.best_position = NaN(S.nbof_generations, P.lengthof_position);
S.switch_at = NaN;
S.success = 0;
retraining_switch = 0;

for g = 2:S.nbof_generations
    
    % Collect the fitness measure from the previous generation
    for i = 1:S.popsize
        G{i,g-1} = A.P.performancecalculator(G{i,g-1}); % calculate fitness
        S.fitness(i,g-1) = getfield(G{i, g-1}.T, S.fitness_measure);
        if isnan(S.fitness(i,g-1))
            S.fitness(i,g-1) = 0;
        end
    end
    
    % Select output patterns from the previous generation
    if strcmp(S.selection_type, 'elitist')
        
        [x, index] =  sortrows(S.fitness, g-1); % ascending order
        
        % The best S.nbof_selected outputs are selected (more, if there is a tie at the lower boundary)
        i = 0;
        while S.fitness(index(numel(index)-S.nbof_selected+1-i)) == S.fitness(index(numel(index)-S.nbof_selected+1))
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
        
        % Store best output (before mutation)
        S.indexof_best(g-1) = index(end);
        S.best_output(g-1,:) = G{index(end), g-1}.T.outputs;
        S.best_position(g-1,:) = G{index(end), g-1}.T.position;
        
    end
    
    % Calculate retraining probability
    S = S.switchingprob_calculator(S,g);
    
    if S.print2screen
        ['Generation No. ' num2str(g-1), ', Fitness = ', num2str(max(S.fitness(:,g-1))), ', Pos = ', num2str(S.best_position(g-1,:)) ]
    end
    
    if max(S.fitness(:,g-1)) >= S.stopping_fitness
        S.nbof_used_generations = g-1;
        S.success = 1;
        break
    end
    
    % Turn retraining switch on/off
    if retraining_switch == 0
        if rand < S.switching_prob
            retraining_switch = 1;
            S.switch_at = g-1;
        else
            retraining_switch = 0;
        end
    end
    
    % "Reproduction": feeding back the selected outputs - retrain and test networks in the current (gth) generation
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
        
        % Copy parent to current generation
        G{i, g} = G{i, g-1};
        
        % Copy (with mutations) selected outputs for triggering
        if S.mutation_rate > 0
            mutationmatrix = double(rand(size(selected_outputs{testing_order(next)})) <= S.mutation_rate);
            if P.inactive_input == 0
                mutated = abs(mutationmatrix - selected_outputs{testing_order(next)});
            end
            if P.inactive_input == -1
                mutationmatrix = sign(mutationmatrix - 0.1) * -1;
                mutated = selected_outputs{testing_order(next)} .* mutationmatrix;
            end
            G{i, g}.D.testingset_I = mutated;
        else
            G{i, g}.D.testingset_I = selected_outputs{testing_order(next)};
        end
        
        % Copy (with mutations) selected outputs for training
        if S.mutation_rate > 0
            mutationmatrix = double(rand(size(selected_outputs{training_order(next)})) <= S.mutation_rate);
            if P.inactive_input == 0
                mutated = abs(mutationmatrix - selected_outputs{training_order(next)});
            end
            if P.inactive_input == -1
                mutationmatrix = sign(mutationmatrix - 0.1) * -1;
                mutated = selected_outputs{training_order(next)} .* mutationmatrix;
            end
            G{i, g}.D.trainingset = mutated;
        else
            G{i, g}.D.trainingset = selected_outputs{training_order(next)};
        end
        
        % Forget
        G{i, g}.W.state = G{i, g}.W.state * (1-S.forgetting_rate);
        
        % Retrain
        if rand < S.retraining * retraining_switch
            G{i, g} = TrainAttractor(G{i, g});
        end
        
        % Test
        G{i, g} = TestAttractor_general(G{i, g});
        
        next = next+1;
        if next > numel(selected_outputs)
            next = 1;
        end
        
    end
    
    % Delete all but the last population to save memory
    if S.save_pop == 0
        for i = 1:size(G,1)
            G{i,g-1}=[];
        end
    end
    
end

%% Fitness of the last generation

if g == S.nbof_generations && S.success == 0
    
    % Collect the fitness measure
    for i = 1:S.popsize
        G{i,g} = A.P.performancecalculator(G{i,g}); % calculate fitness
        S.fitness(i,g) = getfield(G{i, g}.T, S.fitness_measure);
        if isnan(S.fitness(i,g))
            S.fitness(i,g) = 0;
        end
    end
    
    % Select best pattern
    if strcmp(S.selection_type, 'elitist')
        
        [x, index] =  sortrows(S.fitness, S.nbof_generations); % ascending order
        
        % Store best output
        S.indexof_best(g) = index(end);
        S.best_output(g,:) = G{index(end), g}.T.outputs;
        S.best_position(g,:) = G{index(end), g}.T.position;        
        
    end
    
    S = S.switchingprob_calculator(S,g+1); % this calculates the position too
    
    % Print
    if S.print2screen
        ['Generation No. ' num2str(g), ', Fitness = ', num2str(max(S.fitness(:,g))), ', Pos = ', num2str(S.best_position(g,:)) ]
    end
    
    if max(S.fitness(:,g)) >= S.stopping_fitness
        S.success = 1;
    end
    
    % Delete unused generations
    S.nbof_used_generations = g;
    %G{:, g+1:end} = [];
    % S.fitness(:,g+1:end) = [];
    % S.indexof_best(:,g+1:end) = [];
    % S.best_output(g+1:end,:) = [];
end

S.runningtime_min = toc/60;








