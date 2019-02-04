function [c] = get_centroid(x)
%CENTROID

p = polyshape(x(1:56),x(57:end));

[x,y] = centroid(p);

c = [x,y];

end

