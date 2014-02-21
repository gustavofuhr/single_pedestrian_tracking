% 
% USAGE
%  patches = describe_initial_patches(patches, image, options)
%
% INPUT
%  image - RGB image (conversion will be performed, if needed)
% 
function patches = describe_initial_patches(patches, image, options)

if strcmp(options.feature_type, 'color_hist') 
    % using the histograms, the image is converted to Lab
    c = makecform('srgb2lab');
    image = applycform(image, c);
    image = image(:,:,2:3); % only the color channels
end

for i=1:size(patches,2)
    roi = int16(patches(i).roi);
    roi_image = image(roi(2,1):roi(2,2), roi(1,1):roi(1,2), :);
    
    % extract the features for each patch
    if strcmp(options.feature_type, 'color_hist')
        patches(i).hists = image2color_hist(roi_image, options); 
    elseif strcmp(options.feature_type, 'covariance')
        [patches(i).mean, patches(i).covariance] = image2covariance(roi_image);        
    end
end


