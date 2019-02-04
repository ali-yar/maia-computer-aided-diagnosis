clc;clear all;close all;

filename = 'shapes.txt' ;
delimiterIn = ' ' ;
headerlinesIn = 0;
A = importdata (filename, delimiterIn, headerlinesIn);

X = A(1:size(A,1)/2,:);
Y = A(57:end,:);

% figure,
% plot(X,Y);

centredX = X - mean(X);
centredY = Y - mean(Y);

% figure,
% plot(centredX,centredY);

len = vecnorm([centredX;centredY]);
normX = centredX ./ len;
normY =  centredY ./ len;

sum(normX.^2) + sum(normY.^2);

A = [normX; normY];

 
meanX = sum(normX,2) / 40;
meanY = sum(normY,2) / 40;

figure,
plot(meanX, meanY);

mean_vec = [meanX;meanY];
it = 0;

while it < 4
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
       vecX = s * (cos(theta)*vecX + sin(theta)*vecY) - meanX;
       vecY = s * (-sin(theta)*vecX + cos(theta)*vecY) - meanY;
       A(:,i) = [vecX;vecY];
    end
    mean_vec = mean(A, 2);
    it = it + 1;
end

X = A(1:size(A,1)/2,:);
Y = A((size(A,1)/2+1):end,:);

figure,
plot(X,Y);

covar = cov(A);
[V,D] = eig(covar);
