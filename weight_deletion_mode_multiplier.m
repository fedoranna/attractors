function eliminated = weight_deletion_mode_probabilistic( W, P, diagonal)
 nbof_eliminated = round(  numel(W.state) * (1-P.connection_density)   );
 eliminated = randperm(numel(W.state), nbof_eliminated);
 eliminated = sort([eliminated, diagonal]);
end

