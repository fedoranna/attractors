function A = calculate_performance_trees(A)

%% Target and actual performance

apexA = A.D.apices_tetrahedron(1,:);
apexB = A.D.apices_tetrahedron(2,:);
apexC = A.D.apices_tetrahedron(3,:);
apexDtarget = A.D.apices_tetrahedron(4,:);
apexDtarget = round(apexDtarget);
sidetarget = A.P.side_tetrahedron;

unit = numel(A.T.outputs)/3;
x4 = sum(A.T.outputs(1:unit)==1);
y4 = sum(A.T.outputs(unit+1:unit*2)==1);
z4 = sum(A.T.outputs(unit*2+1:unit*3)==1);
apexD = [x4,y4,z4];
A.T.apexD = apexD;
A.T.position = A.T.apexD;

%% Error measures

A.T.sidediff = abs(round(distance_3D(apexD,apexA))-sidetarget) + abs(round(distance_3D(apexD,apexB))-sidetarget) + abs(round(distance_3D(apexD,apexC))-sidetarget);
A.T.positiondiff = distance_3D(apexD,apexDtarget);
A.T.activationdiff = abs(x4-apexDtarget(1)) + abs(y4-apexDtarget(2)) + abs(z4-apexDtarget(3));

%% Possible fitness measures

A.T.fitness_side = 1 - (A.T.sidediff/(3*sidetarget));
A.T.fitness_position = 1 - (A.T.positiondiff/100);
A.T.fitness_activation = 1 - (A.T.activationdiff/A.P.nbof_neurons);

%% Fitness of all possible points

% apexA = [15, 10, 0];
% apexB = [15, 90, 0];
% apexC = [84, 50, 0];
% apexDtarget = [38, 50, 65]; 
% sidetarget = 80;
% 
% F = [];
% next = 1;
% for x = 0:1:100
%     for y = 0:1:100
%         for z = 0:1:100
%             apexD = [x,y,z];
%             
%             sidediff = abs(round(distance_3D(apexD,apexA))-sidetarget) + abs(round(distance_3D(apexD,apexB))-sidetarget) + abs(round(distance_3D(apexD,apexC))-sidetarget);
%             positiondiff = distance_3D(apexD,apexDtarget);
%             activationdiff = abs(x-apexDtarget(1)) + abs(y-apexDtarget(2)) + abs(z-apexDtarget(3));
%             
%             fitness_side = 1 - (sidediff/(3*sidetarget));
%             fitness_position = 1 - (positiondiff/100);
%             fitness_activation = 1 - (activationdiff/300);
%             
%             F(1,next) = fitness_side;
%             F(2,next) = fitness_position;
%             F(3,next) = fitness_activation;
%             next = next+1;
%         end
%     end
% end
% 
% figure
% hold all
% plot(F(1,:))
% plot(F(2,:))
% plot(F(3,:))
% legend('f. side', 'f. position', 'f.activation')
% 
% min(F') %  0.3167   -0.0281    0.4100
% max(F') %  1 1 1 
%  
% 
%             
% 
