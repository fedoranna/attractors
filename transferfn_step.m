% Step function with an output=0 or 1
% weightedsum and threshold have to be the same size

function activation = transferfn_step(weightedsum, threshold, dummy)

activation = double(weightedsum > threshold); % double is needed to convert the values to scalar from logical, because matrix multiplication of logical values is not supported 