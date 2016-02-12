function A = InitializeAttractor_trees(P)

P.end_of_initializing_parameters = '--------';
P.ID = datestr(now, 'yyyy-mm-dd-HH-MM-SS');

%% Delete unnecessary parameters

if strcmp(func2str(P.activation_function), 'transferfn_piecewise_linear') || strcmp(func2str(P.activation_function), 'transferfn_step')
    P.gain_factor = NaN;
end

%% Calculate tetrahedron

a = P.side_tetrahedron;
x1 = P.apex_tetrahedron(1,1);
y1 = P.apex_tetrahedron(1,2);
z1 = P.apex_tetrahedron(1,3);

x2 = x1;
y2 = y1 + a;
z2 = z1;

x3 = x1 + a * sqrt(3/4);
y3 = y1 + a/2;
z3 = z1;

x4 = x1 + a/sqrt(12);
y4 = y1 + a/2;
z4 = z1 + a * sqrt(2/3);

P.apices_tetrahedron = [
    x1, y1, z1;
    x2, y2, z2;
    x3, y3, z3;
    x4, y4, z4];
    
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
unit = P.lengthof_patterns/3;
D.testingset = NaN(1, P.lengthof_patterns);
D.testingset(1:unit) = double(rand(1,unit) <= mean([x1,x2,x3])/unit);
D.testingset(unit+1:unit*2) = double(rand(1,unit) <= mean([y1,y2,y3])/unit);
D.testingset(unit*2+1:unit*3) = double(rand(1,unit) <= mean([z1,z2,z3])/unit);

%D.testingset = zeros(1, P.lengthof_patterns)-1;

% If input consists of -1 and +1; might not be unique!
if P.inactive_input == -1
    D.testingset = sign(D.testingset-0.1);
end

% Make testingset unique
% D.testingset = unique(D.testingset, 'rows');
% P.nbof_patterns = size(D.testingset, 1);

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

%% Choose trainingset

if strcmp(P.trainingseed, 'noseed')
    rng shuffle
    s = rng;
    P.trainingseed = s.Seed;
    rng(P.trainingseed, 'twister');
else
    rng(P.trainingseed, 'twister');
end

k = round(P.nbof_patterns * P.trained_percentage/100); % number of training patterns
if k < P.nbof_patterns
    D.selected_patterns = randperm(P.nbof_patterns, k);
    D.trainingset = D.testingset(D.selected_patterns,:);
else
    D.trainingset = D.testingset;
end

%% Layer of neurons

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

