% 
% USAGE
%  [i_mean, i_covariance] = image2covariance(image)
%
function [i_mean, i_covariance] = image2covariance(image)

[h,w,c] = size(image);

observations = double(reshape(image, h*w, c, 1));    

i_mean = mean(observations)'; %mean vector
i_covariance = cov(observations);