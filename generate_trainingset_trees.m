
function D = generate_trainingset_trees(P, D)

unit = P.lengthof_patterns/3;
D.trainingset = NaN(P.nbof_pretrainingpatterns, P.lengthof_patterns);
nb = P.nbof_pretrainingpatterns / size(P.sparseness_pretraining,1);

for i = 1:size(P.sparseness_pretraining,1)
    tol = nb * (i-1) + 1;
    ig = nb * i;    
    D.trainingset(tol:ig, 1:unit)          = double(rand(nb,unit) <= P.sparseness_pretraining(i,1));
    D.trainingset(tol:ig, unit+1:unit*2)   = double(rand(nb,unit) <= P.sparseness_pretraining(i,2));
    D.trainingset(tol:ig, unit*2+1:unit*3) = double(rand(nb,unit) <= P.sparseness_pretraining(i,3));    
end

% If input consists of -1 and +1
if P.inactive_input == -1
    D.trainingset = sign(D.trainingset-0.1);
end