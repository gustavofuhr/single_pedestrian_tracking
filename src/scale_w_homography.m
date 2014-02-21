function tracker = scale_w_homography(tracker, H)

% now move the left and right points of the center of translation
tracker.gpoint_lr = tracker.gpoint_lr + repmat(tracker.wd_vector, [1 2]);

% projects back these left and right point to see the new width
new_corners  = wcs2ics([tracker.gpoint_lr; ones(1,2)], H);

new_width    = norm(new_corners(:,1) - new_corners(:,2));

scale = new_width/tracker.w;

% scales all the patches
tracker = scale_patches(tracker, scale);
