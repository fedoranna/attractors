% Calculates the Eucledian distance of two vectors
% Anna Fedor, Nov. 10. 2011

function distance = Hamming_distance(v1, v2)

distance = sum(v1~=v2);

