%% Load parameters

clear all
addpath(genpath('C:\Users\Anna\SkyDrive\Documents\MATLAB\'));
load('C:\Users\Anna\SkyDrive\Documents\MATLAB\params_trees_1.mat')

%% Modify parameters

B.folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\7. Trees\';
B.popseeds = [];     % 704; random seed of independent runs
S.popsize = 10;                     % number of attractor networks in the population
S.nbof_generations = 30;             % maximum number of generations
S.selected_perc = 10;               % [0, 100]; the selected percentage of individuals for reproduction

P.pretraining = '2D';               % Method for generating the initial trainingset: 'random', '2D', 'fromtestingset'
P.initial_input = 'derived';        % Method for generating the initial testingset: 'random' or 'derived'

%% Run

[B,S,P,G] = run_AttractorPop_trees(B,S,P);

%% Artefact?!
% B.popseeds =      383     549     659
% S.popsize =       100     10      10
% S.selected_perc = 20      20      10
%
% z coordinate jumps to 100 quickly after first phase

% In which generation does big z appear?
S.best_positionD
for i = 1:size(S.best_positionD,1)
    if S.best_positionD(i,3) > 90
        g = i
        break
    end
end

% In which network does big Z appear?
for i = 1:S.popsize
    if G{i,g}.T.apexD(3) > 90
        network = i
    end
end

%% In the next generation the big Z pattern spreads to all networks
% that get it as testingset or trainingset?
for i = 1:S.popsize
    if G{i,g+1}.T.apexD(3) > 90
        i
        sum(G{network,g}.T.outputs == G{i,g+1}.D.testingset_I);
        sum(G{network,g}.T.outputs == G{i,g+1}.D.trainingset);
    end
end

%% How does big z appear?

% There cannot be anything special about the trainingset and the testingset
% because they were the same for all networks
S.best_positionD(g-1,:)
[sum(G{network,g}.D.testingset_I(1:100)==1), sum(G{network,g}.D.testingset_I(101:200)==1), sum(G{network,g}.D.testingset_I(201:300)==1)]
[sum(G{network,g}.D.trainingset(1:100)==1), sum(G{network,g}.D.trainingset(101:200)==1), sum(G{network,g}.D.trainingset(201:300)==1)]

% There is never mutation, because the best pattern is already mutated
% before being selected
S.best_positionD(g-1,:)
for i = 1:S.popsize
    testingset = [sum(G{i,g}.D.testingset_I(1:100)==1), sum(G{i,g}.D.testingset_I(101:200)==1), sum(G{i,g}.D.testingset_I(201:300)==1)];
    trainingset = [sum(G{i,g}.D.trainingset(1:100)==1), sum(G{i,g}.D.trainingset(101:200)==1), sum(G{i,g}.D.trainingset(201:300)==1)];
    [testingset; trainingset]
end

%%
% Is the weight matrix special?
for i = 1:S.popsize
    figure
    imagesc(G{i,25}.W.state, [-0.1, 0.1])
    colorbar
    title(num2str(i))
end

% Is the weight matrix special?
for i = 1:S.popsize
    figure
    hist(G{i,g}.W.state(:))
    title(num2str(i))
end

% Is the z part of the weight matrix special?

% Its min, max or range is not special
weightdistr = NaN(S.popsize,3);
for i = 1:S.popsize
    weightdistr(i,:) = [min(G{i,g}.W.state(:)), max(G{i,g}.W.state(:)), range(G{i,g}.W.state(:))];
end

%% Testing and updates

A = G{network,g};

updates = 4;
inputs = NaN(updates,300);
ItimesW = NaN(updates,300);
outputs = NaN(updates,300);

A.L.state = A.D.testingset_I(1,:);
for r = 1:updates
    previous_output = A.L.state;
    z = sum(previous_output(201:300)==1);
    %A.L.state = A.P.activation_function(previous_output * A.W.state, A.L.thresholds, A.P.gain_factor);
    A.L.state = sign(previous_output * A.W.state);
    change = sum(A.L.state ~= previous_output);
    [z, change]
    
    inputs(r,:) = previous_output;
    ItimesW(r,:) = previous_output * A.W.state;
    outputs(r,:) = A.L.state;
end

figure
subplot(1,3,1)
imagesc(inputs)
title('inputs')
subplot(1,3,2)
imagesc(ItimesW)
title('I*W')
colorbar
subplot(1,3,3)
imagesc(outputs)
title('outputs')

% Only 1 bit changes (No. 122: +1 -> -1)
sum(inputs(1,:)==inputs(2,:))
sum(sign(inputs(1,:)*A.W.state)==1)
sum(sign(inputs(2,:)*A.W.state)==1)

%% Testing all networks in one round

% Páratlan számú update-nél egy csomó másik networknél is nagy lesz z; de
% annál az egynél páros update-eknél is úgy marad
updates = 4;

inputs = NaN(S.popsize,300);
ItimesW = NaN(S.popsize,300);
outputs = NaN(S.popsize,300);
for i = 1:S.popsize
    A = G{i,g};
    A.P.timeout = updates;
    A = TestAttractor_general(A);
    outputs(i,:) = A.T.outputs;
end

figure
imagesc(outputs)
title('outputs')






