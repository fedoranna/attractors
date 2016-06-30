% Calculates the average normalized Eucledian distance of rows of a matrix
% Anna Fedor, Nov. 10. 2011

function distance = Hamming_distance_avg(M)

hds = NaN(size(M,1));
for i = 1:size(M,1)
    for j = (i+1):size(M,1)
        hds(i,j) = Hamming_distance_normalized(M(i,:), M(j,:));
    end
end
distance = nanmean(hds(:));

