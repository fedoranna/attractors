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

D.testingset_I = D.testingset;
D.testingset_O = D.testingset;

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

nbof_eliminated = round(  numel(W.state) * (1-P.connection_density)   );
W.eliminated = randperm(numel(W.state), nbof_eliminated);

if P.allow_selfloops
    diagonal = [];
else
    diagonal = 1 : P.nbof_neurons+1 : P.nbof_neurons*P.nbof_neurons;
end
W.eliminated = sort([W.eliminated, diagonal]);
W.state(W.eliminated) = 0;

%% Store

A.P = P;
A.D = D;
A.L = L;
A.W = W;

