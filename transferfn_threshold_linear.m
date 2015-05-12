function activation = transferfn_threshold_linear(weightedsum, threshold)

activation = NaN(size(weightedsum));
for i = 1:numel(weightedsum)
    if weightedsum(i) <= threshold
        activation(i) = 0;
    else 
        activation(i) = weightedsum(i);
    end
end
