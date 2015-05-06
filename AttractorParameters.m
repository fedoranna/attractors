% Simple attractor network

%% Parameters

clear all
addpath(genpath('C:\Matlab_functions\Attractor\'));

% Initialization
P.layerinit = @zeros;
P.weightinit = @zeros;          % rand, randn (zeros does not work, because increment is always 0)
P.randmin = 0;                  % rand: the lower limit of randomly initialized weights; randn and zeros: has to be 0!!!
P.randmax = 0.1;                % rand: the upper limit of randomly initialized weights; randn: the multiplier of the standard normal distribution
P.weightseed = 'noseed';               % 'noseed' or a number bw 0 and 2^31-2;
P.usebias = 0;
P.biasvalue = 1;

% Input
P.inputseed = 'noseed';
P.nbof_patterns = 20;

% Training items
P.trainingseed = 'noseed';
P.trained_percentage = 100;           % percentage of selected items

% Size of layers
P.nbof_neurons = 500;

% Connection densities
P.connection_density = 1;

% Evaluating
P.test_performance = 1;
%P.upper_TH = 0.6;               % threshold of activation for answer = 1
%P.lower_TH = 0.4;               % threshold of activation for answer = 0
P.timeout = 10;                 % the number of allowed timesteps

% Stop conditions
P.criteriaperc = 100;            % training stops at this perfromance percentage
P.beeps = 3;                    % Do you want a very annoying reminder when the run is over?

% Saving results
P.folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\';
% P.print2screen = P.test_performance; % 0 for NO, anynumber for the period to print
% P.save_matfile = 1;             % save matfile
P.save_figure = 0;              % save figure
% P.save_2excel = 1;              % save summary of results to excel

'Parameter reading done';

%%

% [P, W, L, T] = Attractor(P);
% T.percof_correct

%% Population of Attractors

repetitions = 5;
variable = 0:20:100;
meanfitness = NaN(repetitions, numel(variable));

for r = 1:repetitions    
    
    S.popsize = 100;
    S.popfitness = NaN(1, S.popsize);
    
    seeds = randperm(30000);
    counter = 0;    
    
    for p = 1:numel(variable)
        
        P.trained_percentage = variable(p);
        S.popfitness = NaN(1, S.popsize);
        for i = 1:S.popsize
            
            counter = counter + 1
            P.weightseed = seeds(counter);
            P.inputseed = seeds(counter + 10000);
            P.trainingseed = seeds(counter + 20000);

            [P, W, L, T] = Attractor(P);
            S.popfitness(i) = T.percof_correct;
            
        end
        meanfitness(r,p) = mean(S.popfitness);
        
    end    
end

figure
hold all
for r = 1:repetitions
    plot(variable, meanfitness(r,:))
end

xlabel('Connection density')
ylabel('Average score')
set(gca, 'YLim', [0,101])

%% Beep

for i = 1:P.beeps
    beep
    pause(0.5)
end































