% the threshold is the middle of the linear part
% the length of the linear part is always 1

function activation = transferfn_piecewise_linear(weightedsum, threshold, dummy)

activation = NaN(size(weightedsum));
for i = 1:numel(weightedsum)
    if weightedsum(i) <= threshold(i)-0.5
        activation(i) = 0;
    elseif weightedsum(i) >= threshold(i)+0.5
        activation(i) = 1;
    else activation(i) = weightedsum(i);
    end
end
