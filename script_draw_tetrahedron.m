clear all
addpath(genpath('C:\Users\Anna\OneDrive\Documents\MATLAB\'));
load('C:\Users\Anna\OneDrive\Documents\MATLAB\Attractor\params_trees_4.mat');

%%

color = [
    0 0 0;
    0 0 0;
    0 0 0;
    1 0 0];

apices_tetrahedron = calculate_tetrahedron(P.apex_tetrahedron, P.side_tetrahedron);
A = apices_tetrahedron(1,:);
B = apices_tetrahedron(2,:);
C = apices_tetrahedron(3,:);
D = apices_tetrahedron(4,:);

figure
tetrahedron = [A;B;C;D];

scatter3(tetrahedron(:,1), tetrahedron(:,2), tetrahedron(:,3), 100, color, 'fill')
hold all
plot3([A(1),B(1)], [A(2),B(2)], [A(3),B(3)], 'k')
plot3([A(1),C(1)], [A(2),C(2)], [A(3),C(3)], 'k')
plot3([B(1),C(1)], [B(2),C(2)], [B(3),C(3)], 'k')

plot3([A(1),D(1)], [A(2),D(2)], [A(3),D(3)], 'k')
plot3([B(1),D(1)], [B(2),D(2)], [B(3),D(3)], 'k')
plot3([C(1),D(1)], [C(2),D(2)], [C(3),D(3)], 'k')

xlim([0 100])
ylim([0 100])
zlim([0 100])
axis square
