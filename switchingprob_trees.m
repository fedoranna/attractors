function S = switchingprob_trees(S,g)

% Number of repetitions of positions
x=sum(S.best_output(g-1,1:100)==1);
y=sum(S.best_output(g-1,101:200)==1);
z=sum(S.best_output(g-1,201:300)==1);
S.best_position(g-1,:) = [x,y,z];

reps = (g-1) - size(unique(S.best_position(1:g-1,:), 'rows'), 1);
if reps == 0
    reps = 1;
end

% Task time function
a=S.switchingprob_a;
b=S.switchingprob_b;
c=S.switchingprob_c;

trial_dep = (1-(a.^(b.*g)));
rep_dep = 1./(reps.^c);
S.switching_prob = rep_dep .* trial_dep;

