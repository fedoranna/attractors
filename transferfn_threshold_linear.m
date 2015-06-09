% threshold linear activation function
% weightedsum and threshold can be a number or an array of numbers

function activation = transferfn_threshold_linear(weightedsum, threshold, gain)

activation = NaN(size(weightedsum));
for i = 1:numel(weightedsum)
    if weightedsum(i) <= threshold(i)
        activation(i) = 0;
    else 
        activation(i) = gain * (weightedsum(i) - threshold(i));
    end
end

