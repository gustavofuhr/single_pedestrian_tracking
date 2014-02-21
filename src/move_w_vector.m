% 
% Move patches using a single vector
% wf_vector is the filtered world vector
% 
% USAGE
%  target = move_w_vector(target, wf_vector, options)
%
function tracker = move_w_vector(tracker, wf_vector, options)


for i = 1:size(tracker.patches, 2)
    % first of all we need to project the vector using all
    % the patches heights and move them accordly.
    dvector = wvector2ivector(tracker.patches(i), tracker, wf_vector, options);
    
    tracker.patches(i).roi = [tracker.patches(i).roi(1,:) + dvector(1); ...
                              tracker.patches(i).roi(2,:) + dvector(2)];
end