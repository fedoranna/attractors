function D = generate_testingset_robots(P, D)

unit = P.lengthof_patterns/8;
D.testingset = NaN(1, P.lengthof_patterns);

for i = 1:8
    tol = unit*(i-1)+1;
    ig = unit*i;
    D.testingset(tol:ig) = double(rand(1,unit) <= P.sparseness_provoking(i));
end

% If input consists of -1 and +1
if P.inactive_input == -1
    D.testingset = sign(D.testingset-0.1);
end