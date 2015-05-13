% Step function with a threshold=0.5, output=0 or 1

function activation = transferfn_tanh(weightedsum, threshold, dummy)

activation = tanh(weightedsum);
