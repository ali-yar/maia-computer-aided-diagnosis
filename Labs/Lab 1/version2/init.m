% Adapt this file to your needs

% index of the image to kept as test image (the rest is used as train set).
% It follows the order in dataset, e.g. '4' refers to '0003.jpg'.
test_idx = 4; 

% -1 to manually control the iterations (by pressing any key) or a positive 
% value ' t' to pause for 't' seconds
pause_time = 1;

% how many iterations to run for convergence of the ASM
total_iterations = 7;

% size of the multilevel pyramid (put 1 for no pyramid)
pyr_size = 1;

% load the gray-level profile data
isLoadProfile = 0;

% size of the graylevel profile (total will be 2*K+1)
% each element of the array correspond to a level in the pyramid 
K = [15 15 15 15]; % make sure it is same length as the pyr_size

% idxRemove = []; % index of images to be discarded from TRAIN set


% data directories
dir_shapes = './data/shapes/' ;
dir_img = './data/images/' ;
addpath(genpath(dir_shapes), genpath(dir_img), genpath('./data/'));

% build TRAIN data
train_landmarks = importdata ('shapes.txt', ' ', 0); % import landmarks data
trainFiles = dir(fullfile(dir_img,'*.jpg')); % read train data
train_imgs = cell(pyr_size,numel(trainFiles)); % rows are levels, cols are images
for i = 1:numel(trainFiles)
    im = imread(fullfile(dir_img,trainFiles(i).name));
    im = rgb2gray(im);
    train_imgs{pyr_size,i} = im;
    for j = pyr_size-1:-1:1
        train_imgs{j,i} = impyramid(train_imgs{j+1,i}, 'reduce');
    end
end

% build TEST data
test_landmarks = train_landmarks(:,test_idx);
test_img = train_imgs(:,test_idx);

if exist('idxRemove') && numel(idxRemove)>0
    % remove TEST and other images from TRAIN data
    idxRemove = [test_idx idxRemove];
    train_landmarks(:,idxRemove) = [];
    train_imgs(:,idxRemove) = [];
else
    % remove only TEST image from TRAIN data
    train_landmarks(:,test_idx) = [];
    train_imgs(:,test_idx) = [];
end





