
% output is -1,0 or +1

function activation = transferfn_step2(weightedsum, threshold, dummy)

activation = sign(weightedsum-threshold);

% bin = weightedsum > threshold;
% activation = sign(bin-0.1);