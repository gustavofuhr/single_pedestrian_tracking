%
% Initialize the tracker of a single person using the initialization frame
% 
% USAGE
%   tracker = init_tracker(options, im_first_frame)
% 
function tracker = init_tracker(options, im_first_frame)

% computes the patches' locations
% create_patches returns the min and max for both x and y of all the patches
tracker.patches = create_patches(options.head_point, options.foot_point, options.min_patch_height, options.patch_width);

% compute the patches height in the world coordinate frame
tracker.patches = compute_patches_height(tracker.patches, options);

tracker.patches = describe_initial_patches(tracker.patches, im_first_frame, options);

roi = tracker.patches(end).roi;
tracker.w = roi(1,2) - roi(1,1);

% now, I want to know this width in the world coordinate system
u = [roi(1,1); roi(2,2); 1]; v = [roi(1,2); roi(2,2); 1];
tracker.w_world       = distance_wcs(u, v, options.H);
tracker.gpoint_lr     = ics2wcs([u v], options.H);


tracker.gpoint = patch_ground_point(tracker.patches(end), options.H);

% creates the variables where we store the last displacements and ss
tracker.last_ss = zeros(2,2);
tracker.last_displacement = []; % auxiliary variable

tracker.best_matchings = [];
