% Distance of two points from 3D coordinates
% Points A and B should be vectors of their coordinates [x, y, z]

function distance = distance_3D(A, B)

distance = sqrt((A(1)-B(1))^2 + (A(2)-B(2))^2 + (A(3)-B(3))^2 );