function A = calculate_performance_trees(A)

apexA = A.P.apices_tetrahedron(1,:);
apexB = A.P.apices_tetrahedron(2,:);
apexC = A.P.apices_tetrahedron(3,:);
apexDtarget = A.P.apices_tetrahedron(4,:);
sidetarget = A.P.side_tetrahedron;

unit = numel(A.T.outputs)/3;
x4 = sum(A.T.outputs(1:unit)==1);
y4 = sum(A.T.outputs(unit+1:unit*2)==1);
z4 = sum(A.T.outputs(unit*2+1:unit*3)==1);
apexD = [x4,y4,z4];

A.T.apexD = apexD;
A.T.sidediff = abs(distance_3D(apexD,apexA)-sidetarget) + abs(distance_3D(apexD,apexB)-sidetarget) + abs(distance_3D(apexD,apexC)-sidetarget);
A.T.positiondiff = distance_3D(apexD,apexDtarget);
A.T.activationdiff = abs(x4-apexDtarget(1)) + abs(y4-apexDtarget(2)) + abs(z4-apexDtarget(3));

%% Possible fitness measures

A.T.fitness_side = 1 - (A.T.sidediff/(3*A.P.side_tetrahedron));
A.T.fitness_position = 1 - (A.T.positiondiff/100);
A.T.fitness_activation = 1 - (A.T.activationdiff/A.P.nbof_neurons);
