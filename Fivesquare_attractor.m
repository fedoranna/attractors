% Reads in experimental data from matfile and calculates mutation rates for
% the evolutionary model

%% Parameters

clear all

folder = 'C:\Users\Anna\SkyDrive\Documents\DOKUMENTUMOK\INSIGHT\fivesquares_experiment\'; % IO folder
excelfile = 'fivesquares_RESULTS2.xlsx';
datafile = 'Katona_2014.mat';

saveplots = 0;
printresults = 0;
save2excel = 0;

%% Load Data

addpath(genpath(['C:\Users\Anna\SkyDrive\Documents\MATLAB']))
load([folder, datafile]);

%% List of moves, positions and timestamp of moves (.positions, .moves, .timesrow, .nonzero_moves, .nonzero_timesrow)

Data(1).positions = [];     % list of nonzero positions
Data(1).moves = [];         % list of moves including zeros; each row is a move
Data(1).timesrow = [];      % list of timestamp of moves
Data(1).nonzero_moves = [];
Data(1).nonzero_timesrow = [];

for p = 1:numel(Data)               % participant
    for t = 1:size(Data(p).genes,1) % trial
        for m = 1:3                 % move
            
            move = [Data(p).genes(t,m), Data(p).genes(t,m+3)];
            Data(p).positions = [Data(p).positions, nonzeros(move)'];
            Data(p).moves = [Data(p).moves; move];
            Data(p).timesrow = [Data(p).timesrow, Data(p).movetimes(t,m)];
            
            if move(1)~=0 && move(2)~=0
                Data(p).nonzero_moves = [Data(p).nonzero_moves; move];
                Data(p).nonzero_timesrow = [Data(p).nonzero_timesrow, Data(p).movetimes(t,m)];
            end
            
        end
    end
    Data(p).nbof_moves = size(Data(p).nonzero_moves,1);
end

%% Stick positions

Sticks.allpos = 1:180;
Sticks.start = [64 69 71 80 82 84 87 89 91 93 98 100 102 109 111 118];
Sticks.solutions = [
    64 69 71 80 82 86 87 89 93 95 98 100 104 109 111 118;
    64 69 71 80 82 84 87 89 91 93 98 102 118 129 131 136;
    64 69 71 78 82 84 85 87 91 93 96 100 102 109 111 118;
    46 49 51 64 80 84 87 89 91 93 98 100 102 109 111 118
    ];
Sticks.source_inner = [82 89 91 100];
Sticks.source_sides = [69 71 80 84 98 102 109 111];
Sticks.source_tops = [64 87 93 118];
Sticks.target_sides = [49 51 78 86 96 104 129 131];
Sticks.target_tops = [46 85 95 136];
Sticks.target_bigsquare = [62 66 67 73 107 113 116 120];
Sticks.special = sort([Sticks.start, Sticks.target_sides, Sticks.target_tops, Sticks.target_bigsquare]);
Sticks.target_other = Sticks.allpos;
Sticks.target_other(Sticks.special) = [];

%% Converter of grid indexes to xy coordinates

C = NaN(180, 5);
% column #1: original grid index
% column #2: smaller x coordinate
% column #3: larger x coordinate
% column #4: smaller y coordinate
% column #5: larger y coordinate

% Horizontal lines
C(1:90, 1) = 2:2:180;
C(1:90, 4) = reshape(repmat([9:-1:0], 9, 1), 90, 1);
C(1:90, 5) = reshape(repmat([9:-1:0], 9, 1), 90, 1);
C(1:90, 2) = repmat([0:8]', 10, 1);
C(1:90, 3) = repmat([0:8]', 10, 1) + 1;

% Vertical lines
C(91:180, 1) = 1:2:179;
C(91:180, 2) = repmat([0:9]', 9, 1);
C(91:180, 3) = repmat([0:9]', 9, 1);
C(91:180, 4) = reshape(repmat([8:-1:0], 10, 1), 90, 1);
C(91:180, 5) = reshape(repmat([8:-1:0], 10, 1), 90, 1) + 1;

% Space between stick positions
gridspacing = 0.1;
C(1:90,2) = C(1:90,2)+gridspacing;
C(1:90,3) = C(1:90,3)-gridspacing;
C(91:180,4) = C(91:180,4)+gridspacing;
C(91:180,5) = C(91:180,5)-gridspacing;

C = sortrows(C);

%% Draw

stickpos = Sticks.target_other;

% Create axes
f=figure;
axes1 = axes('Parent',f,'ZColor',[1 1 1],'YTick',zeros(1,0),...
    'YColor',[1 1 1],...
    'XTick',zeros(1,0),...
    'XColor',[1 1 1],...
    'TickLength',[0 0],...
    'PlotBoxAspectRatio',[1 1 1]);
axis([-0.5,9.5,-0.5,9.5], 'square')
set(gca, 'XTick', [], 'YTick', [])
set(gca, 'TickLength', [0,0])

% Draw grid
hold all
for i = 1:180
    plot(C(i,2:3), C(i,4:5), 'LineWidth', 3, 'Color', [0.8, 0.8, 0.8])
end

% Draw sticks
for i = 1:numel(stickpos)
    index = stickpos(i);
    plot(C(index,2:3), C(index,4:5), 'LineWidth', 3, 'Color', [0, 0, 0])
end
close

%% The frequency of positions used as sources and targets

% Pooled genes (moves) from all successful participants
allgenes1 = zeros(0,2);
allgenes2 = zeros(0,2);
for p = 1:numel(Data)
    if Data(p).success
        half = floor(Data(p).nbof_moves / 2);
        allgenes1 = [allgenes1; Data(p).nonzero_moves(1:half, :)];
        allgenes2 = [allgenes2; Data(p).nonzero_moves(end-half:end, :)];
    end
end

% Source and target position frequencies
used_as_sources1 = hist(allgenes1(:,1), 1:180);
used_as_targets1 = hist(allgenes1(:,2), 1:180);
used_as_sources2 = hist(allgenes2(:,1), 1:180);
used_as_targets2 = hist(allgenes2(:,2), 1:180);

%% Mutations rates

% Mutation rates in the first half of moves
M(1).source_inner = sum(used_as_sources1(Sticks.source_inner))/sum(used_as_sources1);
M(1).source_sides = sum(used_as_sources1(Sticks.source_sides))/sum(used_as_sources1);
M(1).source_tops = sum(used_as_sources1(Sticks.source_tops))/sum(used_as_sources1);
M(1).target_sides = sum(used_as_targets1(Sticks.target_sides))/sum(used_as_targets1);
M(1).target_tops = sum(used_as_targets1(Sticks.target_tops))/sum(used_as_targets1);
M(1).target_bigsquare = sum(used_as_targets1(Sticks.target_bigsquare))/sum(used_as_targets1);
M(1).target_other = sum(used_as_targets1(Sticks.target_other))/sum(used_as_targets1);

% Mutation rates in the second half of moves
M(2).source_inner = sum(used_as_sources2(Sticks.source_inner))/sum(used_as_sources2);
M(2).source_sides = sum(used_as_sources2(Sticks.source_sides))/sum(used_as_sources2);
M(2).source_tops = sum(used_as_sources2(Sticks.source_tops))/sum(used_as_sources2);
M(2).target_sides = sum(used_as_targets2(Sticks.target_sides))/sum(used_as_targets2);
M(2).target_tops = sum(used_as_targets2(Sticks.target_tops))/sum(used_as_targets2);
M(2).target_bigsquare = sum(used_as_targets2(Sticks.target_bigsquare))/sum(used_as_targets2);
M(2).target_other = sum(used_as_targets2(Sticks.target_other))/sum(used_as_targets2);

M1 = NaN(1,180);
M2 = NaN(1,180);
M1(Sticks.source_inner) = M(1).source_inner;
M1(Sticks.source_sides) = M(1).source_sides;
M1(Sticks.source_tops) = M(1).source_tops;
M1(Sticks.target_sides) = M(1).target_sides;
M1(Sticks.target_tops) = M(1).target_tops;
M1(Sticks.target_bigsquare) = M(1).target_bigsquare;
M1(Sticks.target_other) = M(1).target_other;

M2(Sticks.source_inner) = M(2).source_inner;
M2(Sticks.source_sides) = M(2).source_sides;
M2(Sticks.source_tops) = M(2).source_tops;
M2(Sticks.target_sides) = M(2).target_sides;
M2(Sticks.target_tops) = M(2).target_tops;
M2(Sticks.target_bigsquare) = M(2).target_bigsquare;
M2(Sticks.target_other) = M(2).target_other;

%% Figure of mutation rates

f = figure;
subplot(1,2,1)
title('First half of moves')
set(gca, 'YColor','w', 'YTick',zeros(1,0), 'XColor','w', 'XTick',zeros(1,0), 'TickLength',[0 0])
axis([-0.5,9.5,-0.5,9.5], 'square')
hold all
for i = 1:180
    c=1-M1(i);
    plot(C(i,2:3), C(i,4:5), 'LineWidth', 3, 'Color', [c,c,c])
end
subplot(1,2,2)
title('Second half of moves')
set(gca, 'YColor','w', 'YTick',zeros(1,0), 'XColor','w', 'XTick',zeros(1,0), 'TickLength',[0 0])
axis([-0.5,9.5,-0.5,9.5], 'square')
hold all
for i = 1:180
    c=1-M2(i);
    plot(C(i,2:3), C(i,4:5), 'LineWidth', 3, 'Color', [c,c,c])
end
cim = 'The frequency of grid positions used as targets';
suptitle(cim);

%%









