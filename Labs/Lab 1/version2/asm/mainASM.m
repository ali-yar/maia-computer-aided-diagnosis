clc; clear all; close all;

% read data from txt file
filename = 'shapes.txt' ;
delimiterIn = ' ' ;
headerlinesIn = 0;
A = importdata (filename, delimiterIn, headerlinesIn);

% extraction of x and y component
X = A(1:size(A,1)/2,:);
Y = A(size(A,1)/2+1:end,:);

% figure,
% plot(X,Y);

centredX = X - mean(X);
centredY = Y - mean(Y);

len = vecnorm([centredX;centredY]);
normX = centredX ./ len;
normY =  centredY ./ len;

one = sum(normX.^2) + sum(normY.^2);

A = [normX; normY];

meanX = sum(normX,2) / size(A,2);
meanY = sum(normY,2) / size(A,2);

% figure,
% plot(meanX, meanY);

% shape alignment
mean_vec = [meanX;meanY];
it = 0;
while it < 5
    for i = 1: size(A,2)
       vec = A(:,i); vecX = vec(1:size(A,1)/2); vecY = vec((size(A,1)/2)+1:end);
       
       a = dot(vec,mean_vec) / vecnorm(vec)^2;
       
       b = 0;
       n = size(A,1)/2;
       for j = 1:n
           b = b + (vecX(j)*meanY(j) - vecY(j)*meanX(j));
       end
       b = b / vecnorm(vec)^2; 
       s = sqrt(a^2 + b^2);
       
       
       theta = atan2(b,a);
       vecX = (s * (cos(theta)*vecX - sin(theta)*vecY)); 
       vecY = (s * (sin(theta)*vecX + cos(theta)*vecY)); 
       A(:,i) = [vecX;vecY];
    end
    mean_vec = mean(A, 2);
    it = it + 1;
end

X = A(1:size(A,1)/2,:);
Y = A((size(A,1)/2+1):end,:);

% figure,
%  plot(X,Y);

% pca
covar = cov(A');
[V,D] = eig(covar);

% sorting 
[d,ind] = sort(diag(D),'descend');
D = D(ind,ind);
V = V(:,ind);

D = sum(D,2); % make diagonal matrix as column vector
total_variance = sum(D);

% find the t eigenvalues that constitute 98% of the total variance
max_val = total_variance * 0.98;

s = 0;
for t = 1:length(D)
    s = s + D(t);
    if s >= max_val
        break;
    end
end

% t eigenvalues and eigen vectors
D = D(1:t); 
P = V(:,1:t);

% reading of the hand images
datapath = './hand/images';
addpath(genpath(datapath));

Im = rgb2gray(imread('0000.jpg'));
% imshow(Im);

% gIm = magnitude(sobel(Im));help gra
[Gmag, Gdir] = imgradient(Im,'sobel');
imshow(Gmag,[]);
hold on;
%  matching the shape model and target
b = zeros(t,1);
x = mean_vec + P*b;
plot(x(1:56), x(57:end));

% initialization for the transform
[tx,ty] = getpts;
s = 1500;
ang = 0;
u = x(1:size(x,1)/2);
v = x((size(x,1)/2 + 1):end);

T = poseparam(u,v,tx,ty,s,ang);
% Tx = T(1:size(T,1)/2);
% Ty = T((size(x,1)/2 + 1):end);
plot(T(:,1), T(:,2),'r');

% % computes the norm of the points
Norms = getNorm(T);        
% hold off;
figure,
plot(Norms(:,1),Norms(:,2),'*c')


% while not converged
%     X = model_to_image(x, xt, yt, s, angle);
%     find norms for each point (56 in total)
%     norms = get_norms(X) (56, 2)
%     Y = get_new_points(grad_image, X, norms, norm_range);
%     norm range: find the 20 pixels along the normsearching for maximum
%     gradient
%     xt, yt, s, angle = get_alignment_params(x -> Y)
%     y = image_to_model(Y, xt, yt, s, angle);
%     yy = y / dot(y, x_mean);
%     b = P.T*(yy - x_mean)
%     x = x_mean + P * b;
% end;


