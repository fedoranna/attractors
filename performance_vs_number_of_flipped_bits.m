
N=25;
flipped = zeros(1,numel(G));
for i = 1:numel(G)
    flipped(i) = N-sum(G{i}.D.testingset_I == G{1}.D.testingset_O);
end
flipped';

x=[performance, flipped'/N];
x(:,2) + x(:,4);

% Proportion of nonflipped hits
[x(:,2), 1-x(:,4)] 