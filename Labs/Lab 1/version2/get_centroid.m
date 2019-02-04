function [c] = get_centroid(x)
% CENTROID
% 
% Returns the center of mass of the shape formed by a set of points

p = polyshape(x(1:56),x(57:end));

[x,y] = centroid(p);

c = [x,y];

end

