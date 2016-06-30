function A = InitializeAttractor_general(P)

%% Delete unnecessary parameters

if strcmp(func2str(P.activation_function), 'transferfn_piecewise_linear') || strcmp(func2str(P.activation_function), 'transferfn_step')
    P.gain_factor = NaN;
end

S.end_of_initializing_parameters = '--------';
D.start = 1;

%% Generate initial trainingset to pretrain networks before evolution begins

if strcmp(P.trainingseed, 'noseed')
    rng shuffle
    s = rng;
    P.trainingseed = s.Seed;
    rng(P.trainingseed, 'twister');
else
    rng(P.trainingseed, 'twister');
end

D = P.trainingsetgenerator(P, D);

%% Generate initial provoking patterns (testingset)

if strcmp(P.inputseed, 'noseed')
    rng shuffle
    s = rng;
    P.inputseed = s.Seed;
    rng(P.inputseed, 'twister');
else
    rng(P.inputseed, 'twister');
end

D = P.testingsetgenerator(P, D);

% Complete input
D.testingset_O = D.testingset;
D.testingset_I = D.testingset_O;

% Noisy input
flippingmatrix = double(rand(size(D.testingset_I)) <= (P.noise/100));
if P.inactive_input == 0
    D.testingset_I = abs(flippingmatrix - D.testingset_I);
end
if P.inactive_input == -1
    flippingmatrix = sign(flippingmatrix - 0.1) * -1;
    D.testingset_I = D.testingset_I .* flippingmatrix;
end

% Incomplete input
nbof_deleted = round((P.missing_perc/100) * numel(D.testingset_O));
deleted = randperm(numel(D.testingset_O), nbof_deleted);
D.testingset_I(deleted) = 0;

%% Layer of neurons

L.state = zeros(1,P.nbof_neurons);
L.thresholds = repmat(P.threshold, 1, P.nbof_neurons); % row vector for all neurons for asynchoronous update and individual thresholds

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
        
    case 'Poisson'
        W.masking_matrix = poissrnd(P.connection_density, size(W.state)); % This function is in the Statistics Toolbox
        W.masking_matrix(diagonal) = 0;
end

W.state = W.state .* W.masking_matrix;

%% Store

A.P = P;
A.D = D;
A.L = L;
A.W = W;

