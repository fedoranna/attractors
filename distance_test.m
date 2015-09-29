function [index, distance] = distance_test(output, trained_patterns)

%index % index of the closest trained pattern (the most recently trained pattern is the first)
%distance % distance of the output from the closest trained pattern
%output % the output of the network to one pattern 
%trained_patterns % a matrix of all the trained patterns

distances = NaN(size(trained_patterns,1), 1);
for i = 1:size(trained_patterns,1)
    distances(i) = Hamming_distance(output, trained_patterns(i,:));
end
distances = [distances, [numel(distances):-1:1]'];
distances = sortrows(distances);

distance = distances(1,1);
index = distances(1,2);