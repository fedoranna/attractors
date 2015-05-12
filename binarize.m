%% Transforms the activation of a unit to 1/0

function output = binarize(activity, tolerance, inactive_value)

output = NaN(size(activity));

for i=1:numel(activity)
    
    if activity(i) >= 1-tolerance
        output(i) = 1;
    end
    if activity(i) <= inactive_value+tolerance
        output(i) = inactive_value;
    end
    
end
