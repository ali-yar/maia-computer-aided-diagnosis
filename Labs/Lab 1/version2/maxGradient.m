function [Y] = maxGradient(img, X, normals, srange)
% initialize
Y = zeros(size(X));

% total points
N = size(X,1) / 2;

% img = imgaussfilt(img, 2);
% figure;imshow(img,[]);
img = imgradient(img,'sobel');

% 
% img = mat2gray(img);
% img = im2double(img);
% 
% ii = imbinarize(img,graythresh(img));
% figure;imshow(ii,[]);

m=2;
for i = 1:N
    x_start = X(i) + srange * normals(i,1) * m;
    x_end = X(i) - srange * normals(i,1)* m;
    y_start = X(i+N) + srange * normals(i,2)* m;
    y_end = X(i+N) - srange * normals(i,2)* m;

    x = double(int16([x_start x_end]));
    y = double(int16([y_start y_end]));

    % intensities along the line formed by 2 endpoints
%     [cx, cy, c] = improfile(img,x,y,search_range*2+1);
    [cx, cy, c] = improfile(img,x,y);
    
    % more values are retuned: keep only those within the range in both direction
    cntr = ceil(numel(c)/2);
    ii = cntr-srange;
    jj = cntr+srange;
    cx = cx(ii:jj);
    cy = cy(ii:jj);
    c = c(ii:jj);

    % index of max intensity
    [c, idx] = sort(c, 'descend');
    cx = cx(idx);
    cy = cy(idx);

    Y([i i+N]) = [round(cx(1)) round(cy(1))];

end

end


% IF USING MAX GRADIENT WITHIN GET_NEW_POINTS()
%
% function [Y] = maxGradient(img, X, normals, srange)
% % initialize
% % Y = zeros((2*srange+1),2);
% 
% % total points
% N = size(X,1) / 2;
% 
% img = imgradient(img,'sobel');
% 
% m=2;
% for i = 1:N
%     x_start = X(i) + srange * normals(i,1) * m;
%     x_end = X(i) - srange * normals(i,1)* m;
%     y_start = X(i+N) + srange * normals(i,2)* m;
%     y_end = X(i+N) - srange * normals(i,2)* m;
% 
%     x = double(int16([x_start x_end]));
%     y = double(int16([y_start y_end]));
% 
%     % intensities along the line formed by 2 endpoints
%     [cx, cy, c] = improfile(img,x,y);
%     
%     cx = round(cx);cy = round(cy);
%     
%     % more values are retuned: keep only those within the range in both direction
%     cntr = ceil(numel(c)/2);
%     ii = cntr-srange;
%     jj = cntr+srange;
%     cx = cx(ii:jj);
%     cy = cy(ii:jj);
%     c = c(ii:jj);
% 
%     % sort
%     [c, idx] = sort(c, 'descend');
%     cx = cx(idx);
%     cy = cy(idx);
%     
%     % keep t highest;
%     t = 20;
%     Y = [cx(1:t) cy(1:t)];
% 
% end
% 
% end

