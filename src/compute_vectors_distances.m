% computes the sum distance from each vector to all others
% 
% USAGE
%  distances = compute_vectors_distances(vectors)
%
function distances = compute_vectors_distances(patches)

Np = size(patches, 2);

distances = zeros(1, Np);
for i = 1:Np
    for j=1:Np
        if i ~= j
            d = norm(patches(:,i) - patches(:,j));
            distances(i) = distances(i) + d;
        end
    end
end