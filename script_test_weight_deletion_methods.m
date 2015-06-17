% Testing the speed of deleting nodes in a huge matrix with two different
% methods

%% Parameters

clear all
N = 30000; % max 30 000

%% Weight matrix, deletion matrix

w = rand(N);            % weight matrix
d = 1:2:numel(w);        % deleted weights
dm = ones(size(w));    % deletion matrix
dm(d) = 0;

%% Method a

tic
w(d) = 0;
a = toc;

%% Method b

w = rand(N);  
tic
w = w .* dm; 
b = toc;

%% Compare

[a, b]
'Method b is faster'
