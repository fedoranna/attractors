function S = switchingprob_robots(S,g)

% Number of repetitions of motor positions
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

