% output is -1,0 or +1

function activation = transferfn_step2(weightedsum, threshold, dummy)

activation = sign(weightedsum-threshold);