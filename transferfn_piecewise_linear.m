function activation = transferfn_piecewise_linear(weightedsum, threshold)

activation = NaN(size(weightedsum));
for i = 1:numel(weightedsum)
    if weightedsum(i) <= -threshold
        activation(i) = 0;
    elseif weightedsum(i) >= threshold
        activation(i) = 1;
    else activation(i) = weightedsum(i);
    end
end
