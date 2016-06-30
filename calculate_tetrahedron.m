% Calculates the coordinates of the apices of a regular tetrahedron given
% the first apex and the side

function apices = calculate_tetrahedron(firstapex, side)

a = side;
x1 = firstapex(1,1);
y1 = firstapex(1,2);
z1 = firstapex(1,3);

x2 = x1;
y2 = y1 + a;
z2 = z1;

x3 = x1 + a * sqrt(3/4);
y3 = y1 + a/2;
z3 = z1;

x4 = x1 + a/sqrt(12);
y4 = y1 + a/2;
z4 = z1 + a * sqrt(2/3);

apices = [
    x1, y1, z1;
    x2, y2, z2;
    x3, y3, z3;
    x4, y4, z4];