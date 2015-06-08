function A = InitializeAttractor(P)

P.ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');

%% Generate input pattern and testingset

if strcmp(P.inputseed, 'noseed')
    rng shuffle
    s = rng;
    P.inputseed = s.Seed;
    rng(P.inputseed, 'twister');
else
    rng(P.inputseed, 'twister');
end

% If input consists of 0s and 1s; might not be unique!
if P.inactive_input == 0
    D.testingset = double(rand(P.nbof_patterns, P.lengthof_patterns) <= P.sparseness);
end

% If input consists of -1 and +1; unique, but the number of patterns might be less than specified in the parameters
if P.inactive_input == -1
    D.testingset = 2*floor(2*rand(P.nbof_patterns, P.nbof_neurons))-1; % Create random binary patterns of -1 and +1; each input pattern is a row in the matrix
    D.testingset = unique(D.testingset, 'rows');
    P.nbof_patterns = size(D.testingset, 1);
end

D.testingset_O = D.testingset;
D.testingset_I = D.testingset_O;

% Make input noisy
flippingmatrix = double(rand(size(D.testingset_I)) <= (P.noise/100));
D.testingset_I = abs(flippingmatrix - D.testingset_I);

% Make input incomplete
nbof_deleted = round((P.missing_perc/100) * numel(D.testingset_O));
deleted = randperm(numel(D.testingset_O), nbof_deleted);
D.testingset_I(deleted) = 0;

P.sparseness_input = sparseness(D.testingset); % this is the actual (realized) sparseness

%% Choose trainingset

if strcmp(P.trainingseed, 'noseed')
    rng shuffle
    s = rng;
    P.trainingseed = s.Seed;
    rng(P.trainingseed, 'twister');
else
    rng(P.trainingseed, 'twister');
end

k = round(P.nbof_patterns * P.trained_percentage/100);
D.selected_patterns = randperm(P.nbof_patterns, k);
D.trainingset = D.testingset(D.selected_patterns,:);
D.trainingset = sortrows(D.trainingset);

%% Layer of neurons

L.output = zeros(1, P.nbof_neurons);
L.thresholds = repmat(P.threshold, 1, size(L.output,2)); % row vector for all neurons for asynchoronous update and individual thresholds

%% Weights

if strcmp(P.weightseed, 'noseed')
    rng shuffle
    s = rng;
    P.weightseed = s.Seed;
    rng(P.weightseed, 'twister');
else
    rng(P.weightseed, 'twister');
end

W.state = P.weight_init(P.nbof_neurons) * P.strenght_of_memory_traces;

% Delete diagonal
if P.allow_selfloops
    diagonal = [];
else
    diagonal = 1 : P.nbof_neurons+1 : P.nbof_neurons*P.nbof_neurons;
end

% Delete weights 
switch P.weight_deletion_mode
    
    case 'probabilistic'
        
        nbof_eliminated = round(  numel(W.state) * (1-P.connection_density)   );
        W.eliminated = randperm(numel(W.state), nbof_eliminated);
        W.eliminated = sort([W.eliminated, diagonal]);
        
        W.masking_matrix = ones(size(W.state));
        W.masking_matrix(W.eliminated) = 0;
        
    case 'exact'        
        
        P.connections_per_neuron = P.connection_density * P.nbof_neurons;
        P.loading = P.nbof_patterns/P.connections_per_neuron;
        
        c = P.connections_per_neuron;
        N = size(W.state,1);
        dummy = ones(size(W.state));
        
        dummy(diagonal) = 0;
        for i = 1:N
            avoid = [];
            all = sum(dummy, 1);
            current = all(i);
            todelete = current - c;
            if todelete < 0
                todelete = 0;
            end
            
            choosefrom = find(dummy(:,i)); % the index of nonzero elements
            
            % Avoiding those neurons that already have c weights
            for j = 1:numel(all)
                if all(j) <= c
                    avoid = [avoid, j]; % the index of neurons that already have c weights
                end
            end
            if isempty(avoid) == 0
                for j = numel(avoid) :-1 : 1
                    [row, column, v] = find(choosefrom==avoid(j));
                    choosefrom(row) = [];
                end
            end
            
            % Choosing weights to delete
            if todelete > numel(choosefrom)
                deleted = choosefrom;
            else
                indices = randperm(numel(choosefrom), todelete);
                deleted = choosefrom(indices);
            end
            dummy(deleted,i) = 0;
            dummy(i, deleted) = 0;
        end
        
        % Listing weights to delete
        not_eliminated = find(dummy);
        eliminated = 1:numel(W.state);
        eliminated(not_eliminated) = [];
        W.eliminated = eliminated;
        
        W.masking_matrix = ones(size(W.state));
        W.masking_matrix(W.eliminated) = 0;
        
    case 'poisson'
        W.masking_matrix = poissrnd(P.connection_density, size(W.state)); % This function is in the Statistics Toolbox
                  
end



W.state = W.state .* W.masking_matrix;

%% Store

A.P = P;
A.D = D;
A.L = L;
A.W = W;

