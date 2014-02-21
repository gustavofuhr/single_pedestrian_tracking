% 
% Computes the *weighted vector median filter* to combine the information
% of several vectors resulting in a avarage mean robust to outliers
% OPTIONAL: a set of vectors and match distances that could be add to the filter 
%   these could be predicted_vector or any vector 
% 
% USAGE
%  filtered_vector = wvmf(patches, options, varargin)
%
function filtered_vector = wvmf(patches, options, varargin)

Np = size(patches, 2);

% create the vectors
ws = zeros(1, Np);
% this line is wd_vector because we are performing the WVMF in the world cs
vectors = [patches.wd_vector]; 
m_distances = [patches.match_distance];

% if the predicted vector was included then we include in the vectors
if nargin == 4
    predicted_vector = varargin{1};
    best_matchings = varargin{2};
    vectors = [vectors predicted_vector];
end

% first of all, we need to compute the sum of distances
% between each vector to all others
distances = compute_vectors_distances(vectors);

% beta is defined as the minimum distance
beta = min(distances);
% gamma = 0.15;
gamma = options.wvmf_gamma;

% if only one patch exists, there is no need to compute weight
if Np == 1
    ws = 1;
else
    for i = 1:Np
        ws(i) = exp(-( (distances(i)/beta)^2 + (m_distances(i)/gamma)^2));
    end
end

% the weight associated to the predicted vector is somewhat different
if nargin == 3
    m_dist = median(best_matchings);
    c = 0.5;
    
    w_pred = c*Np*exp(-( (distances(end)/beta)^2 + (m_dist/gamma)^2));
    ws = [ws w_pred];
end

% now compute the filtered vector
p_sum = [0;0];
for i = 1:Np
    p_sum = p_sum + ws(i)*vectors(:,i);
end

filtered_vector = p_sum/sum(ws);


