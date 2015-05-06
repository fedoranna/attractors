% Calculates the Eucledian distance of two vectors
% Anna Fedor, Nov. 10. 2011

function distance = Eucledian_distance_normalized(v1, v2)

distance = sum(abs(v1-v2)) / length(v1);

