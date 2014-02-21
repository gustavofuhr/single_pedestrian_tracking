%
% Runs the tracker, what else did you expect?
%
% USAGE
%  run_tracker(options)
%
function run_tracker(options)

im_first_frame = get_frame(options, options.begin_frame);    

%% initialize the tracker
tracker = init_tracker(options, im_first_frame);

%% shows the first frame
if options.show_frames
    figure;
    % save the initialization patches
    imshow(im_first_frame); hold on;
    plot_patches(tracker.patches); hold off;
    pause(0.1);
    if options.save_frames
        out_frame = sprintf('%strack%s.png', options.out_path, format_int(options.d_mask, options.begin_frame));
        export_fig(out_frame, '-a2');
    end        
    
end

%% initialize parameters
i_result = 1;
predicted = false;
for f = options.begin_frame+1:options.end_frame
    %% print stuff for debug
    fprintf('Frame %d of %d ', f, options.end_frame); tic;    
    im_frame = get_frame(options, f);    
    if options.show_frames
        imshow(im_frame); hold on;
    end
    
    %% computes the prediction vector
    if ~isempty(tracker.last_displacement) % if we have information to compute
        tracker = motion_prediction(tracker);
        predicted = true;
    end
        
    % move each patch individually using the world search region
    if predicted
        tracker = track_patches(tracker, im_frame, options, tracker.predicted_vector);
    else
        tracker = track_patches(tracker, im_frame, options);
    end
    r_patches{i_result}.n_candidates = tracker.n_candidates;
       
    %% compute the displacement vectors in the world coordinate system
    tracker.patches = compute_world_d_vectors(tracker.patches, options);
    
    %% applies the WVMF to the set of individual displacements
    if predicted
        tracker.filtered_vector = wvmf(tracker.patches, options, tracker.predicted_vector, tracker.best_matchings);
    else
        tracker.filtered_vector = wvmf(tracker.patches, options);
    end
    
    %% move patches using the resulting vector
    tracker = move_w_vector(tracker, tracker.filtered_vector, options);
        
    %% update the gpoint in the world
    tracker.wd_vector = tracker.filtered_vector;
    tracker.gpoint    = tracker.gpoint + tracker.wd_vector;    
    
    %% scale the patch using the homography    
    tracker = scale_w_homography(tracker, options.H);    
    
    %% save stuff for prediction
    tracker = compute_motion_information(tracker, options);    
    
    %% plot result frame
    if options.show_frames  
        plot_patches(tracker.patches);
        pause(0.1); hold off;
        
        if options.save_frames
            out_frame = sprintf('%strack%s.png', options.out_path, format_int(options.d_mask, f));
            export_fig(out_frame, '-a2');
        end        
    end
    
    %% save the results
    r_patches{i_result}.patches = tracker.patches;
    r_patches{i_result}.c_point = extract_central_point(tracker.patches);
    i_result = i_result + 1;
    toc;
end

frames = [options.begin_frame:options.end_frame];

% also saves the options in the mat file
save([options.out_path, options.out_filename], 'r_patches', 'frames', 'options');
disp('Done!');







