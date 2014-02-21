% 
% Using the last filtered vectors, compute a motion prediction
% uses the Double Exponential Smoothing technique
% returns also the auxiliary variables ss
% 
% USAGE
%  tracker = motion_prediction(tracker)
%
function tracker = motion_prediction(tracker)

alpha = 0.05;

vt = tracker.last_displacement; 

s1 = alpha*vt + (1 - alpha)*tracker.last_ss(:,1);
s2 = alpha*s1 + (1 - alpha)*tracker.last_ss(:,2);

tracker.predicted_vector = (2 + alpha/(1-alpha))*s1 - (1 + alpha/(1-alpha))*s2;

tracker.last_ss = [s1 s2];