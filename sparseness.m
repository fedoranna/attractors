% According to Rolls, 2012
% sparseness of input patterns or output activations for any values
% activation: rows=patterns, columns=neurons

function a = sparseness(activation)


%%

szamlalo = sum(activation ./ size(activation,2), 2) .* sum(activation ./ size(activation,2), 2);
nevezo = sum((activation .* activation) ./ size(activation,2), 2);

a_for_each_pattern = szamlalo ./ nevezo;

for i = 1:numel(a_for_each_pattern)
    if isnan(a_for_each_pattern(i))
        a_for_each_pattern(i) = 0;
    end
end

a = mean(a_for_each_pattern);

