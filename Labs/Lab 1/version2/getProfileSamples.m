function [S, cx, cy] = getProfileSamples(img,point,normal,range,extra)
% getProfileSamples
% 
% Build a profile for a point by sampling the intensities along a the 
% normal to the point.
% 
% Input:
%   img: (nxm) intensity image
%   point: (1x2) coordinates of the point around which to sample
%   normal: (1x2) normal to the point (gives direction for sampling)
%   range: (scalar) how far to search in either side of the point
%   extra: (scalar) add extra samplings to the profile
% 
% Output:
%   S: ((2*range+1+extra)x1) intensity profile
%   cx: ((2*range+1+extra)x1) x-coordinates of the profile
%   cy: ((2*range+1+extra)x1) y-coordinates of the profile

% margin for the search range
m = 2;

% define the start and end points of the line along the normal
x_start = point(1) + range * normal(1) * m;
y_start = point(2) + range * normal(2) * m;
x_end = point(1) - range * normal(1) * m;
y_end = point(2) - range * normal(2) * m;

x = double(int16([x_start x_end]));
y = double(int16([y_start y_end]));

% intensities along the normal line
[cx, cy, S] = improfile(img,x,y);

% more values are retuned: keep only those within the range in both direction
cntr = ceil(numel(S)/2);
i = cntr-range;
j = cntr+range+extra; % add extra value if doing the derivative afterwards
cx = cx(i:j);
cy = cy(i:j);
S = S(i:j);

end

