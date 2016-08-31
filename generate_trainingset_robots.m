
function D = generate_trainingset_robots(P, D)

unit = P.lengthof_patterns/8;
D.trainingset = NaN(P.nbof_pretrainingpatterns, P.lengthof_patterns);
nb = P.nbof_pretrainingpatterns / size(P.sparseness_pretraining,1);

for i = 1:size(P.sparseness_pretraining,1)
    tol = nb * (i-1) + 1;
    ig = nb * i;    
    for j = 1:8
        tol2 = unit*(j-1)+1;
        ig2 = unit*j;
        D.trainingset(tol:ig, tol2:ig2) = double(rand(nb,unit) <= P.sparseness_pretraining(i,j));
    end
end

% If input consists of -1 and +1
if P.inactive_input == -1
    D.trainingset = sign(D.trainingset-0.1);
end