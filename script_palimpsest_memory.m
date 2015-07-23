clear all
addpath(genpath('C:\Users\Anna\SkyDrive\Documents\MATLAB\'));

%% Change default parameters

load('C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\Attractor_params_Storkey2.mat')
folder = 'C:\Users\Anna\SkyDrive\Documents\MATLAB\Attractor\RESULTS\3. Palimpsest memory\3. Storkey\';

P.inputseed = 1651559639;
P.weightseed = 1651559654;
P.trainingseed = 1651559652;

set = 1;
P.nbof_patterns = 1000;
criteria = 0.95;
morefigures = 0;
forgetting_rates = [0];

P.noise = 5;
P.autothreshold_aftertraining = 1;
P.threshold_algorithm = @set_threshold_aftertraining_det;
P.synchronous_update = 0;

P.sparseness = 0.5;%0.3;
P.connection_density = 1;%0.5;
P.field_ratio = 0;

% P.weight_deletion_mode = 'probabilistic';
% P.inactive_input = 0;
% P.activation_function = @transferfn_step;


%% Non-random input

nonrandom = 0;
if nonrandom == 1
    on = P.nbof_neurons * P.sparseness;
    patterns = zeros(P.nbof_patterns,P.nbof_neurons);
    for i = 1:P.nbof_patterns
        patterns(i, (on*(i-1)+1) : (on*i)) = ones(1,on);
    end
end

%% Run

for f = 1:numel(forgetting_rates)
    P.forgetting_rate = forgetting_rates(f);
    'Running...'
    A = InitializeAttractor(P);
    
    if nonrandom > 0
        A.D.testingset = patterns;
        A.D.testingset_O = A.D.testingset;
        A.D.testingset_I = A.D.testingset_O;
        
        % Noisy input
        flippingmatrix = double(rand(size(A.D.testingset_I)) <= (A.P.noise/100));
        A.D.testingset_I = abs(flippingmatrix - A.D.testingset_I);
        
        % Incomplete input
        nbof_deleted = round((A.P.missing_perc/100) * numel(A.D.testingset_O));
        deleted = randperm(numel(A.D.testingset_O), nbof_deleted);
        A.D.testingset_I(deleted) = 0;
        
        A.P.sparseness_input = sparseness(A.D.testingset); % this is the actual (realized) sparseness
    end
    
    scores = NaN(P.nbof_patterns, floor(P.nbof_patterns/set));
    for i = 1 : floor(P.nbof_patterns/set)
        
        A.D.trainingset = A.D.testingset((i-1)*set+1 : set*i, :);
        A = TrainAttractor(A);
        A = TestAttractor(A);
        scores(:,i) = A.T.scores;
        
    end
    
    %% Save matfile
    
    save([folder, A.P.ID, '.mat'], '-v7.3');
    
    %% Figure: heatmap of scores and number of recalled patterns
    
    figure
    suptitle(['Forgetting rate = ',num2str(P.forgetting_rate),'; Set = ', num2str(set), '; Criteria = ', num2str(criteria)], 10)
    subplot(1,2,1)
    %imagesc(scores, [0.7,1.0])
    imagesc(scores, [0,1])
    %title('Scores')
    ylabel('Patterns')
    xlabel('Training sessions')
    colorbar
    subplot(1,2,2)
    %imagesc(scores>criteria)
    imagesc(scores>criteria, [0,1])
    %title(['Scores > ', num2str(criteria)])
    ylabel('Patterns')
    xlabel('Training sessions')
    colorbar
    %cim = ['palimpsest_', 'P', num2str(P.nbof_patterns),'_set', num2str(set), '_f', num2str(P.forgetting_rate)];
    print('-dpng', '-r200', [folder, A.P.ID, '_palimpsest.png'])
    close
    
    figure
    plot(sum(scores>criteria))
    ylabel('Number of recalled patterns')
    xlabel('Number of training sessions')
    print('-dpng', '-r200', [folder, A.P.ID, '_recalled.png'])
    close
    
    %% More figures
    
    if morefigures
        figure
        hist(A.W.state(:))
        title('Weight distribution after the 1st session')
        print('-dpng', '-r200', [folder, A.P.ID, '_weights1.png'])
        close
        
        figure
        boxplot(scores)
        xlabel('Training sessions')
        ylabel('Scores')
        print('-dpng', '-r200', [folder, A.P.ID, '_scores.png'])
        close
        
        figure % This only works if there were more than 1 pattern and more than 1 session
        toplot = [sum(scores>0.9)',  sum(scores>0.91)', sum(scores>0.92)',  sum(scores>0.93)',  sum(scores>0.94)',  sum(scores>0.95)',  sum(scores>0.96)',  sum(scores>0.97)',  sum(scores>0.98)',  sum(scores>0.99)'];
        boxplot(toplot, 'labels', 0.90:0.01:0.99)
        ylabel('Number of recalled patterns (score > criteria)')
        xlabel('Criteria')
        title(['Training set = ', num2str(set), ' patterns'])
        print('-dpng', '-r200', [folder, A.P.ID, '_boxplots.png'])
        close
        
        figure
        correlations = NaN(P.nbof_patterns);
        for i = 1:P.nbof_patterns
            for j = i+1 : P.nbof_patterns
                corr_matrix = corrcoef(A.D.testingset(i,:), A.D.testingset(j,:));
                correlations(i,j) = corr_matrix(1,2);
            end
        end
        hist(correlations(:))
        xlabel('Correlations')
        ylabel('Number of pairs')
        print('-dpng', '-r200', [folder, A.P.ID, '_correlations.png'])
        close
        
    end
    
    %% Diagnostics
    
    % d = diag(scores, 0);
    % d_felette = diag(scores, 1); % trained in the previous session
    % d_alatta = diag(scores,-1); % not trained yet, if set=1; trained together with diag if set>1
    % %boxplot([d1,d2])
    %
    % [h,p] = ttest2(d_felette,d_alatta, 'Tail', 'right'); % d_felette>d_alatta?
    % new_result = [set, P.forgetting_rate, mean(d_felette),mean(d_alatta),p];
    % result=[result;new_result];
    %result
    %[A.P.inputseed, A.P.weightseed, A.P.trainingseed]
    
end

%% Beep

for i = 1:3
    beep
    pause(0.5)
end








