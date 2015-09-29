% Calculates the coordinates of a tetrahedron

%% Start with one of the apices and the side

clear all

a = 80;
x1 = 15;
y1 = 10;
z1 = 0;

x2 = x1;
y2 = y1 + a;
z2 = z1;

x3 = x1 + a * sqrt(3/4);
y3 = y1 + a/2;
z3 = z1;

x4 = x1 + a/sqrt(12);
y4 = y1 + a/2;
z4 = z1 + a * sqrt(2/3);

A = [x1, y1, z1];
B = [x2, y2, z2];
C = [x3, y3, z3];
D = [x4, y4, z4];
tetrahedron = [A;B;C;D];

%h = sqrt(2/3) * a; % height of the tetrahedron
l = sqrt(a^2 - (a/2)^2); % height of the triangle
r = sqrt(3/8) * a; % the radius of the circumsphere (distance of M from the veritces)
x5 = x1 + l/3;
y5 = y1 + a/2;
z5 = z1 + r/3;
M = [x5, y5, z5];

%tetrahedron
%[distance_3D(A,B), distance_3D(A,C),distance_3D(A,D), distance_3D(B,C), distance_3D(B,D), distance_3D(C,D)]

tolerance=0.4;
Cr = C;
Dr = round(D);
abs(distance_3D(Dr,A)-80) < tolerance
abs(distance_3D(Dr,B)-80) < tolerance
abs(distance_3D(Dr,Cr)-80) < tolerance

%[distance_3D(M,A), distance_3D(M,B),distance_3D(M,C), distance_3D(M,D)]

%% Start with the midpoint and the radius

if 1==0
    clear all
    
    x5 = 50;
    y5 = 50;
    z5 = 50;
    r = 50;
    
    a = r / sqrt(3/8);
    l = sqrt(a^2 - (a/2)^2);
    
    x1 = x5 - l/3;
    y1 = y5 - a/2;
    z1 = z5 - r/3;
    
    x2 = x1;
    y2 = y1 + a;
    z2 = z1;
    
    x3 = x1 + a * sqrt(3/4);
    y3 = y1 + a/2;
    z3 = z1;
    
    x4 = x1 + a/sqrt(12);
    y4 = y1 + a/2;
    z4 = z1 + a * sqrt(2/3);
    
    A = [x1, y1, z1];
    B = [x2, y2, z2];
    C = [x3, y3, z3];
    D = [x4, y4, z4];
    tetrahedron = [A;B;C;D];
end

%% Draw tetrahedron

figure
color = [
    0 0 0;
    0 0 0;
    0 0 0;
    1 0 0];
scatter3(tetrahedron(:,1), tetrahedron(:,2), tetrahedron(:,3), 50, color, 'fill')
xlim([0 100])
ylim([0 100])
zlim([0 100])
hold

plot3([A(1),B(1)], [A(2),B(2)], [A(3),B(3)], 'k')
plot3([A(1),C(1)], [A(2),C(2)], [A(3),C(3)], 'k')
plot3([B(1),C(1)], [B(2),C(2)], [B(3),C(3)], 'k')

