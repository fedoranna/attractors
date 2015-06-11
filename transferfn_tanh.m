% Step function with a threshold=0.5, output=0 or 1
% weightedsum and threshold have to be the same size

function activation = transferfn_tanh(weightedsum, dummy, dummy)

activation = tanh(weightedsum);
