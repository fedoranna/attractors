function activation = transferfn_threshold_linear(weightedsum, threshold, gain)

activation = NaN(size(weightedsum));
for i = 1:numel(weightedsum)
    if weightedsum(i) <= threshold
        activation(i) = 0;
    else 
        activation(i) = gain * (weightedsum(i) - threshold);
    end
end

