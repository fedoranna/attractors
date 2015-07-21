% According to Rolls, 2012
% sparseness of input patterns or output activations for any values
% activation: rows=patterns, columns=neurons

function a = sparseness(activation)

%% The mean of the sparseness of the patterns

if sum(activation(:)<0) == 0
    szamlalo = sum(activation ./ size(activation,2), 2) .^ 2;
    nevezo = sum((activation .^ 2) ./ size(activation,2), 2);

    a_for_each_pattern = szamlalo ./ nevezo;

    % If a pattern is all 0s, sparseness should be 0
    for i = 1:numel(a_for_each_pattern)
        if isnan(a_for_each_pattern(i))
            a_for_each_pattern(i) = 0;
        end
    end

    a = mean(a_for_each_pattern);

else % if there are negative values in "activation", sparseness calculates the proportion of 1s
    szamlalo = sum(activation == 1, 2);
    nevezo = size(activation, 2);
    
    a_for_each_pattern = szamlalo ./ nevezo;
    a = mean(a_for_each_pattern);
end
    

%% For the whole matrix (a slightly different result because of averaging)

% N = numel(activation);
% szamlalo = (sum(activation(:)) / N) ^ 2;
% nevezo = sum((activation(:) .^ 2) / N);
% a = szamlalo/nevezo;
% if isnan(a)
%     a = 0;
% end

