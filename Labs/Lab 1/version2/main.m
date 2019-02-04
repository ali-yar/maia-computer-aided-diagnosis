% clear
close all; clear; clc;

tic;

% launch initial parameters and set up
init;

total_shapes = size(train_landmarks,2);
total_points = size(train_landmarks,1) / 2;

% get graylevel profiles
if isLoadProfile == 1
    load("trainProfile.mat");
else
    disp("Building the Train Profile ...");
    trainProfile = getTrainProfile(train_imgs, train_landmarks, pyr_size, K);
    disp("Train Profile completed.");
end

% align all shapes
S = alignShapes(train_landmarks);
% figure, plot(S(1:total_points,:), S(total_points+1:end,:));

% get mean shape
[meanS, meanS_x, meanS_y] = meanShape(S, true);
% figure, plot(meanS_x, meanS_y);

% get eigenvectors (projection matrix) and eigenvalues with PCA
[P,D] = projectionMatrix(S);

% total modes of model shape
t = size(P,2);

% model shape modes initialized to 0
b = zeros(t,1);

disp("Init completed.");
toc;

% run from the coarsest resolution to the finest
for r = 1:pyr_size
    target_img = test_img{r};

    % get user input for initial landmarks
    if r == 1
        scale = 2^(pyr_size-r);
        x = meanS + P*b;
        [t_x, t_y, scale, ang, search_range] = initLandmarks(target_img,x,scale);
        tic;
    end
    if pyr_size > 1 && r == pyr_size
        % adjust for the next level of the pyramid
        scale = scale*2; t_x = t_x*2; t_y = t_y*2;
        X = model_to_image((meanS + P*b), t_x, t_y, scale, ang);
        [~, ~, ~, ~, search_range] = initLandmarks(target_img,X,0);
    elseif r>1
        % adjust for the next level of the pyramid
        scale = scale*2^(pyr_size-r);
        t_x = t_x*2^(pyr_size-r); t_y = t_y*2^(pyr_size-r);
        X = model_to_image((meanS + P*b), t_x, t_y, scale, ang);
        [~, ~, ~, ~, search_range] = initLandmarks(target_img,X,0);
    end
    
%     figure; imshow(target_img,[]); hold on;
%     X = model_to_image(meanS, t_x, t_y, scale, ang);
%     plot(X(1:56), X(57:end),'-', 'LineWidth',1);

    meanP = trainProfile.mean{r}; 
    covP = trainProfile.covariance{r};

    figure;
    for it = 1:total_iterations
        % model shape point positions
        x = meanS + P*b;
        
        % transfer the model shape points to the image space
        X = model_to_image(x, t_x, t_y, scale, ang);

        % compute the normals
        normals = getNormals(X);
        
        % display model shape normals on figure
        showNormals(target_img,X,normals,search_range,it,pause_time);

        % find best points in target image
        Y = get_new_points(target_img, X, normals, search_range, K(r), meanP, covP);
        
        % if want to use the max gradient approach, uncomment below
        % Y=maxGradient(target_img,X,normals,search_range); 
       
        plot(Y(1:56), Y(57:end),'-*g', 'LineWidth',1);

        % find the parameters that transform x to Y
        [t_x, t_y, scale, ang] = get_alignment_params(x, Y);

        % project Y into the model co-ordinate frame
        y = image_to_model(Y, t_x, t_y, scale, ang);
         
%         figure; plot(x(1:56), x(57:end),'-', 'LineWidth',1); hold on;
%         plot(y(1:56), y(57:end),'-', 'LineWidth',1); hold off;

        % project y into the tangent plane to mean shape
         yy = y / dot(y, meanS);

        b = P' *(yy - meanS);

        % set the max and min value that b can have
        b = min(b,3*sqrt(D(1:t))); 
        b = max(b,-3*sqrt(D(1:t)));

    %     figure; plot(x(1:56), x(57:end),'-', 'LineWidth',1); hold on;
    %     plot(y(1:56), y(57:end),'-', 'LineWidth',2);

        if pause_time < 0
            pause;
        else
            pause(pause_time);
        end
    end
    
    % compute the error between result and ground truth
    err = metric(X,test_landmarks*size(target_img,1));
    
    % show result along with ground truth
    X = model_to_image((meanS + P*b), t_x, t_y, scale, ang);
    showResultAndTruth(target_img, X, test_landmarks*size(target_img,1), err);
    
    disp("ASM completed.");
    toc;
    
end


% Utils functions

function showNormals(img,X,normals,search_range,it,pause_time)
    clf;
    imshow(img,[]); hold on;
    plot(X(1:56), X(57:end),'-', 'LineWidth',1);
    plot([X(1:56)-search_range*normals(:,1) X(1:56)+search_range*normals(:,1)]',...
         [X(57:end)-search_range*normals(:,2) X(57:end)+search_range*normals(:,2)]');
    if pause_time < 0
        title(sprintf("iteration = %d  (press any key to continue)", it));
    else
       title(sprintf("iteration = %d", it));
    end
end

function  showResultAndTruth(img, X, GT,err)
    figure;
    imshow(img,[]); hold on;
    plot(X(1:56), X(57:end),'-r*', 'LineWidth',1);hold on;
%     for k = 1:56
%         text(X(k),X(k+56),num2str(k)); hold on;
%     end
    plot(GT(1:56), GT(57:end),'-go', 'LineWidth',1);
%     for k = 1:56
%         text(GT(k),GT(k+56),num2str(k)); hold on;
%     end
    hold off;
    title(sprintf("Results (red) VS Ground Truth (green) - err=%.2f",err));
end














