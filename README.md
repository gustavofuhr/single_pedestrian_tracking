
Overview
=========

The package contains the code for the pedestrian (single) tracker proposed in the paper:

	Fuhr, G. ; Jung, C. R. . Robust Patch-Based Pedestrian Tracking 
using Monocular Calibrated Cameras. In: SIBGRAPI 2012 - Conference on 
Graphics, Patterns and Images, p. 166-173, 2012. 

If you use the following code in our experiments, please cite the above publication.

Information about the project can be found in: http://inf.ufrgs.br/~gfuhr/?file=research
Soon, there will be extensions of the code and improvements in this webpage.

For question about the code/method please contact Gustavo Fuhr
at gfuhr@inf.ufrgs.br.

Requirements
============

The source code was tested in MATLAB 64-bin in version
7.12 (R2001a). However, you should not have problems in running the
code in different platforms and newer versions of MATLAB.

Running the code
================
1. Unpack the code
2. Run the main.m file using MATLAB

All the important configurations of the tracker are set in the main.m. This package contains
 an example main.m with configurations used in the datasets presented in the paper. However 
you should download the sequences separately.

Configuration of main.m
=======================

All the configurations are in a structure called options. The following commentaries can 
help you to modify the values to the desired ones.

- options.feature_type: the type of feature used in matching. Two options are possible: 
'covariance' that employs statistical feature based on the mean and covariance matrices 
of RGB values of pixels. 'color_hist' is the feature that relies on a* and b* color 
histograms as proposed in the paper. The second one shows better results in the 
general case. (default: color_hist)

- options.n_bins: if color histograms are used, you can use set the number of bins to 
use for the histograms. (default: 64)

- options.walking_speed: the maximum pedestrian walking speed expected in the sequence 
in meters per second (default: 1.5)

- options.relaxation_parameter: relaxation parameter to increase the size of the search 
region to recover from failure (default: 0.5)

- options.world_search_sample_step: the sampling interval to create the candidates after 
the world search region is projected in the image (default: 2). Smaller values will 
create more candidates and consequently increase computational time.

- options.show_frames: boolean field to show the results of tracking.
(default: true)

- options.save_frames: save the frames in the options.out_path folder.
It requires the package export_fig to work (export_fig can be obtained
at: http://www.mathworks.com/matlabcentral/fileexchange/23629-exportfig)
(default: false)

- options.image_pref: The prefix of the string used to create the filenames.

- options.file_ext: The file extension of the image files.

- options.d_mask: The mask of integers used to create the numeric part of the 
filename. For instance, if the options.image_pref = 'data/fr', options.file_ext = 'png' 
and options.d_mask = 3, the filenames will be created as 'data/fr001.png', 
'data/fr002.png', etc.

- options.calib_filename: The path to the xml file containing the camera calibration. 
The xml is expected to be in the format provided with the PETS dataset. The pets.xml 
in this package is an example of such calibration file.

- options.world_unit: The measurement unit of the calibration file. The possible values 
are 'm' (meters), 'cm' (centimeters) and 'mm' (milimeters).

- options.video_fps: the frames per second of the sequence. This is used when defining 
the search region in the world. See the papers for details.

- options.begin_frame: the first frame that will be used in the sequence.

- options.end_frame: the number of the last frame to be processed.

- options.head_point: the point [x;y] in the head of the target to
be tracked.

- options_foot_point: foot point of the target [x;y].

- options.min_patch_height: the height with which the pets will be created
in the initialization.

- options.patch_width: the width of the patches at initialization.


Extracting the foot and head points

The script click_foot_head.m is included in this package to help the user initialize 
new targets using two clicks. The parameters of the dataset are the same as presented 
in the previous section. See the code for an example and more details.

Output
======

A file with the trackers results (positions) is stored in a .mat file named with the 
parameter options.out_filename.

Enjoy and please send us feedback!

