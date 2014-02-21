% 
% Tracks the patches searching in a region that is defined in the world
% coordinate frame
%
% Note: if color histograms are used, the im_frame must be a Lab image
% with only two channels (a and b). This is to avoid recalculation.
% 
% USAGE
%  tracker = track_patches(tracker, im_frame, options, predicted_vector)
%
function tracker = track_patches(tracker, im_frame, options, predicted_vector)

if strcmp(options.feature_type, 'color_hist')
    % using the histograms, the image is converted to Lab
    c = makecform('srgb2lab');
    im_frame = applycform(im_frame, c);
    im_frame = im_frame(:,:,2:3); % only the color channels
end

pgpoint = patch_ground_point(tracker.patches(end), options.H);
% if the predicted_vector was computed the search region is centered in
% this point
if nargin == 4
    pgpoint = pgpoint + predicted_vector;
end

pts = world_search_region(pgpoint, options.world_search_radius*2, options.H);
if options.show_frames, plot_quadrilateral(pts, [0.3, 0.3, 0.3]); end;
p_candidates = sample_quadrilateral(pts, options.world_search_sample_step);

% stores the current number of candidates in the tracker
tracker.n_candidates = size(p_candidates, 2);

original_roi  = tracker.patches(end).roi;
original_foot = [(original_roi(1,1)+original_roi(1,2))/2; original_roi(2,2)];

for i = 1:size(tracker.patches, 2);
    % for each patch find the matching within the search window
    min_b = Inf;
    best_candidate = zeros(2);
    for c = p_candidates
        % c_vector is the difference from the tracker foot and
        % the point candidate
        c_vector = c - original_foot;
        
        modified_roi = [tracker.patches(i).roi(1,:) + c_vector(1); tracker.patches(i).roi(2,:) + c_vector(2)];

        % only consider the proposed roi if it is within the image size
        if modified_roi(1,1) >= 1 && modified_roi(2,1) >= 1 && modified_roi(1,2) <= size(im_frame,2) ...
                && modified_roi(2,2) <= size(im_frame,1)
            
            m_roi = int16(modified_roi);
            % extracts the portion of the image concerned by the
            % modified_roi
            roi_image = im_frame(m_roi(2,1):m_roi(2,2), m_roi(1,1):m_roi(1,2), :);
            
            if strcmp(options.feature_type, 'color_hist')
                c_hists = image2color_hist(roi_image, options);
                b = 0.5*sum(bhattacharyya(tracker.patches(i).hists, c_hists));
            elseif strcmp(options.feature_type, 'covariance')
                [mu2, c2] = image2covariance(roi_image);
                
                % now compute the bhattacharrya distance
                mu1 = tracker.patches(i).mean; c1 =  tracker.patches(i).covariance;
                b = (1/8)*([mu1 - mu2]'*inv([(c1 + c2)/2])*(mu1-mu2));
                b = b + 0.5*log( (norm(c1+c2)/2) / sqrt(norm(c1)*norm(c2)) );
            end
            
            if b < min_b
                min_b = b;
                best_candidate = modified_roi;
            end
        end        
    end
    % instead of updating the roi of the patch we store the displacement vector
    tracker.patches(i).d_vector = [best_candidate(1,1) - tracker.patches(i).roi(1,1); ...
        best_candidate(2,1) - tracker.patches(i).roi(2,1)];
    % also stores the matching distance
    tracker.patches(i).match_distance = min_b;
end