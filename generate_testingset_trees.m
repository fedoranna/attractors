function D = generate_testingset_trees(P, D)

D.apices_tetrahedron = calculate_tetrahedron(P.apex_tetrahedron, P.side_tetrahedron);

unit = P.lengthof_patterns/3;
D.testingset = NaN(1, P.lengthof_patterns);
D.testingset(1:unit) = double(rand(1,unit) <= P.sparseness_provoking(1));
D.testingset(unit+1:unit*2) = double(rand(1,unit) <= P.sparseness_provoking(2));
D.testingset(unit*2+1:unit*3) = double(rand(1,unit) <= P.sparseness_provoking(3));

% If input consists of -1 and +1
if P.inactive_input == -1
    D.testingset = sign(D.testingset-0.1);
end