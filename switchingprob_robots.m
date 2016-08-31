function S = switchingprob_robots(S,g)

% Number of repetitions of motor positions
unit = numel(S.best_output(g-1,:)) / 8;

for i = 1:8
    tol = unit*(i-1)+1;
    ig = unit*i;
    S.best_position(g-1,i) = sum(S.best_output(g-1,tol:tol+unit/2-1)==1) - sum(S.best_output(g-1,tol+unit/2:ig)==1);
end

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

