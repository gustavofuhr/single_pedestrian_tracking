% plot a quadrilateral connecting adjancent point and the last with 
% the first
function plot_quadrilateral(points, color)

if nargin == 2
    c = color;
else
    c = 'r';
end

plot([points(1,:) points(1,1)], [points(2,:) points(2,1)], '--', 'Color', c, 'LineWidth', 1.5);