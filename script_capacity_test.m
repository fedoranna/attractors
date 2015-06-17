clear all

N = 100; % number of neurons
k = 0.2; % a misterious constant between 0.2 and 0.3

%% Capacity in Hopfield networks

% P_Hopfield = 0.14 * C;

%% Capacity vs number of connections per neuron

sparseness = 0.2;   % proportion of 1s in the input
C = 1:N;            % number of connections per neuron; =N-1 in Hopfield model; C<<N in Rolls model

figure
a = sparseness^2 / sparseness;
capacity = (C * k) / (a * log(1/a));    
plot(C, capacity)
xlabel('Number of connections per neuron')
ylabel('Capacity of the network')

%% Capacity vs number of 1s in the input

sparseness = 0.1 : 0.1 : 1;   % proportion of 1s in the input
C = N * 0.1;           % number of connections per neuron; =N-1 in Hopfield model; C<<N in Rolls model

figure
a = (sparseness .* sparseness) ./ sparseness;
capacity = (C * k) ./ (a .* log(1./a));    
plot(sparseness, capacity)
xlabel('Proportion of 1s in the input')
ylabel('Capacity of the network')

%% Example in Rolls, 2012 paper, p47

k = 0.2:0.01:0.3;
C = 12000;
a = 0.02;

capacity = (C * k) / (a * log(1/a)); % in the paper capacity = 36000 -> k was about 0.235    
