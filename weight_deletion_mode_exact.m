function eliminated = weight_deletion_mode_exact( W, P,diagonal)

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
end

