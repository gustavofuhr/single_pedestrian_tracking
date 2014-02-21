clc; close all; clear;
format long;

dataset = 'pets_s01';

%% parameters of the features
options.feature_type   = 'color_hist'; % {'color_hist', 'covariance'}
options.n_bins = 64;

%% search region
options.walking_speed = 1.5; % in m/s
options.relaxation_parameter = 0.5;
options.world_search_sample_step = 2;

%% vizualization
options.show_frames = true;
options.save_frames = false; % requires export_fig

%% output parameters
options.out_path = 'out/';
options.out_filename = ['results_', dataset, '.mat'];

%% dataset/sequence parameters
if strcmp(dataset(1:4), 'pets') % PETS dataset
    options.image_pref       = '~/datasets/pets/Crowd_PETS09/S2/L1/Time_12-34/View_001/frame_';
    options.calib_filename   = '~/datasets/pets/cparsxml/View_001.xml';
    options.d_mask           = 4;
    options.file_ext         = 'jpg';    
    options.world_unit       = 'mm';
    options.min_patch_height = 20; 
    options.video_fps        = 7;
elseif strcmp(dataset(1:10), 'towncentre') % Towncentre sequence
    options.image_pref      = '~/datasets/towncentre/';
    options.calib_filename  = '~/datasets/towncentre/towncentre_calib.xml';
    options.world_unit      = 'm';
    options.video_fps       = 25;    
    options.d_mask          = 5;
    options.file_ext        = 'png';       
    options.world_unit      = 'm';
    options.video_fps       = 25;
end

if strcmp(dataset, 'pets_s01')
    % pets dataset, subjet s01
    options.begin_frame    = 658;
    options.end_frame      = 741;
    options.head_point     = [740; 303]; 
    options.foot_point     = [735; 418];     
    options.patch_width    = 28;    
elseif strcmp(dataset, 'pets_s02')
    % pets dataset, subjet s02
    options.begin_frame    = 137;
    options.end_frame      = 284;    
    options.head_point     = [722; 247]; 
    options.foot_point     = [718; 343];     
    options.patch_width    = 20;        
elseif strcmp(dataset, 'pets_s03')
    % pets dataset, subjet s03
    options.begin_frame    = 48;
    options.end_frame      = 393;
    options.head_point     = [712; 260]; 
    options.foot_point     = [708; 372];     
    options.patch_width    = 28;                     
elseif strcmp(dataset, 'towncentre_1')    
    % towncentre_1 sequence
    options.begin_frame      = 274;
    options.end_frame        = 792;    
    options.head_point       = [60; 659]; 
    options.foot_point       = [92; 879];    
    options.patch_width      = 60;
    options.min_patch_height = 40;  
elseif strcmp(dataset, 'towncentre_2')
    % towncentre_2 sequence   
    options.begin_frame      = 2074;    
    options.end_frame        = 2443;
    options.head_point       = [1584; 14];
    options.foot_point       = [1577; 156];
    options.min_patch_height = 25; % minimum size of the rectangle
    options.patch_width      = 32;       
end

%%
options = validate_options(options);
disp(options); % shows the options

%% runs the tracker!
run_tracker(options);