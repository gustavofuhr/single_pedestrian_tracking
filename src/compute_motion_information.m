%
% saves information that is going to be used to predict a displ. vector
% 
% USAGE
%   target = compute_motion_information(target, options)
%
function tracker = compute_motion_information(tracker, options)


% save the best matching distance to compute a weight in the wvmf
                
best_d = get_best_matching_distance(tracker.patches, tracker.filtered_vector);
tracker.best_matchings = [tracker.best_matchings best_d];
if size(tracker.best_matchings, 2) > options.s_temporal_window
    tracker.best_matchings = tracker.best_matchings(end-options.s_temporal_window+1:end);
end

tracker.last_displacement = tracker.wd_vector;
