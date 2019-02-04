% clear
close all; clear; clc;

% -1 to manually con trol the iterations (by pressing any key) or a positive 
% value 't' to pause for 't' seconds
pause_time = 0;

% how many iterations to run for convergence of the active shape
total_iterations = 15;

% data directories
dir_shapes = './data/shapes/' ;
dir_img = './data/images/' ;
addpath(genpath(dir_shapes), genpath(dir_img));

% read train data
shapes = importdata ('shapes.txt', ' ', 0);

% read model image
target_img = imread('0003.jpg');
target_img = rgb2gray(target_img);

% total samples
total_shapes = size(shapes,2);
total_points = size(shapes,1) / 2;

% center and (unit) scale the shapes
S = normalizeShapes(shapes);

% figure, plot(shapes(1:total_points,:),shapes(total_points+1:end,:));title("Normalized shapes");

% alignment
S = align(S);
% figure, plot(S(1:total_points,:), S(total_points+1:end,:));

% mean shape
[meanS, meanS_x, meanS_y] = meanShape(S, true);

% get projection matrix from PCA
[P,D] = projectionMatrix(S);

% total shape params
t = size(P,2);

% shape params initialized to 0
b = zeros(t,1);

% gradient of target image
% grad_img = imgradient(target_img,'sobel');
% grad_img = imread("grad_img.jpeg");
% grad_img = edge(target_img,'Prewitt', 0.1);
grad_img = imgradient(target_img);

% get user input for initial landmarks
[t_x, t_y, scale, ang, search_range] = initLandmarks(target_img,meanS);

figure;
% imshow(target_img,[]); hold on;
% X = model_to_image(meanS, t_x, t_y, scale, ang);
% plot(X(1:56), X(57:end),'-', 'LineWidth',1);

for it = 1:total_iterations
    % model points
    x = meanS + P*b;

    % pose params
    X = model_to_image(x, t_x, t_y, scale, ang);

    % compute the normals
    normals = getNorm(X);
    
    clf;
    imshow(grad_img,[]); hold on;
    plot(X(1:56), X(57:end),'-', 'LineWidth',1);
    plot([X(1:56)-search_range*normals(:,1) X(1:56)+search_range*normals(:,1)]',...
         [X(57:end)-search_range*normals(:,2) X(57:end)+search_range*normals(:,2)]');
    if pause_time < 0
        title(sprintf("iteration = %d  (press any key to continue)", it));
    else
       title(sprintf("iteration = %d", it));
    end
    
    
	% find best points in target image
    Y = get_new_points(grad_img, X, normals, search_range);
    plot(Y(1:56), Y(57:end),'-*g', 'LineWidth',1);
%     plot(Y(1:56), Y(57:end),'-', 'LineWidth',1);
    
    % find the parameters that transform x to Y
    [t_x, t_y, scale, ang] = get_alignment_params(x, Y);

    % project Y into the model co-ordinate frame
    y = image_to_model(Y, t_x, t_y, scale, ang);
    
    % project y into the tangent plane to mean shape
    yy = y / dot(y, meanS);

    b = P' *(yy - meanS);
    
    for j = 1:t
        if abs(b(j)) >= 3*sqrt(D(j))
            b(j) = (3*sqrt(D(j))) * b(j) / abs(b(j));
        end
    end

%     figure;
%     plot(x(1:56), x(57:end),'-', 'LineWidth',1);
%     hold on;
%     plot(y(1:56), y(57:end),'-', 'LineWidth',2);
    
    if pause_time < 0
        pause;
    else
        pause(pause_time);
    end
end

X = model_to_image(x, t_x, t_y, scale, ang);

figure; imshow(target_img,[]); hold on;
plot(X(1:56), X(57:end),'-', 'LineWidth',1);
 
% figure; imshow(grad_img,[]); hold on;
% plot(X(1:56), X(57:end),'-', 'LineWidth',1);
