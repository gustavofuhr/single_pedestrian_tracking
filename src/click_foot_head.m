% SCRIPT
% this script is used to click in the head and in the foot of a given
% subject using the parameters of a calibrated camera
clear all; close all; clc;

% PETS dataset
options.image_suf      = '~/datasets/pets/Crowd_PETS09/S2/L1/Time_12-34/View_001/frame_';
options.calib_filename = '~/datasets/pets/cparsxml/View_001.xml';
options.world_unit     = 'mm';
options.d_mask         = 4;
options.file_ext       = 'jpg';
options.init_frame     = 48;

% TownCentre dataset
% options.image_suf      = '~/datasets/oxford/TownCentre_frames/';
% options.calib_filename = '~/datasets/oxford/towncentre_calib.xml';
% options.world_unit     = 'm';
% options.d_mask         = 5;
% options.file_ext       = 'png';
% options.init_frame     = 630;

[K, Rt] = parse_xml_calibration_file(options.calib_filename);
H = Rt2homog(Rt, K);

% shows the first frame
first_image = sprintf('%s%s.%s', options.image_suf, format_int(options.d_mask, options.init_frame), options.file_ext);
im_first_frame = imread(first_image);
imshow(im_first_frame); hold on;

disp('Click in the foot please');
[foot_x, foot_y] = ginput(1);
plot(foot_x, foot_y, '.r', 'MarkerSize', 16.0);

% then, we compute the ground point of this
p = [foot_x; foot_y; 1];

gpoint    = inv(H)*p;
gpoint(1) = gpoint(1)/gpoint(3);
gpoint(2) = gpoint(2)/gpoint(3);
gpoint    = gpoint(1:2);

step       = convert_unit('m', options.world_unit, 0.01);
max_height = convert_unit('m', options.world_unit, 2.0);

for z=0:step:max_height
    mp = K*Rt*[gpoint; z; 1];
    mp(1) = mp(1)/mp(3);
    mp(2) = mp(2)/mp(3);
    plot(mp(1), mp(2), '.b');
end
plot(foot_x, foot_y, '.r');

% keyboard;

disp('Click in the head please (blue line)');
[head_x, head_y] = ginput(1);
plot(head_x, head_y, '.r', 'MarkerSize', 16.0);


fprintf('\nLines for the main.m file:\n');
fprintf('options.head_point = [%d; %d];\n', round(head_x), round(head_y));
fprintf('options.foot_point = [%d; %d];\n', uint16(foot_x), uint16(foot_y));
