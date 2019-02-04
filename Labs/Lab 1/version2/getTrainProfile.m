function [trainProfile] = getTrainProfile(trainData,landmarksMatrix,levels,K)
% getTrainProfile
% 
% Build a statistical model of the gray-level profile.
% For each landmark, sample the intensities along the normal vector to
% obtain a profile. Compute the mean profile and covariance matrix of each 
% landmark across all images.
% 
% Notation reference:
%   N: total images
%   n: total landmark points
% 
% Input:
%   trainData: (1xN cell) contains the train images
%   landmarksMatrix: (2nxN) coordinates of landmark points
%   levels: (scalar) the depth of the multi-resolution pyramid
%   K: (1xlevels) search length along the normal vector to each landmark
% 
% Output:
%   trainProfile: (struct) mean profile and covariance for every landmark

total_shapes = size(landmarksMatrix,2);
total_points = size(landmarksMatrix,1)/2;

trainProfile = struct();


for r = 1:levels
   
    % 3D matrix to store all samples for all images
    % the i-th column is the sampled profile of the i-th landmark
    % the (:,:,k) matrix refers the k-th image/hand
    Profile = zeros(2*K(r)+1,total_points,total_shapes);

    for i = 1:total_shapes
        % read the image
        img = trainData{r,i};
        
        % get the corresponding landmarks coordinates
        landmarks = landmarksMatrix(:,i);
        % convert to pixel coordinates and adapt to current resolution
        landmarks = landmarks * size(img,1);
        
        % get the normals given the landmarks
        normals = getNormals(landmarks);

%         figure; imshow(img,[]); hold on;
%         plot(landmarks(1:total_points), landmarks(total_points+1:end),'*');
        
        for j = 1:total_points
            % the landmark's coordinates        
            L = landmarks([j,j+total_points]);
            % the landmark's normal
            N = normals(j,:);
            % sample intensities through the normal.
            g = getProfileSamples(img,L,N,K(r),1);
            % derivative
            g = diff(g);
            % normalize
            g = g / sum(abs(g));
            % add to the matrix
            Profile(:,j,i) = g;
        end
    end

    % compute the mean w.r.t. each landmark along all images
    meanP = mean(Profile,3);

    % compute the covariance w.r.t. each landmark
    covP = cell(1,total_points);
    for i = 1:total_points
        tmp = reshape(Profile(:,i,:),[size(Profile,1),total_shapes]);
        covP{i} = cov(tmp');
    end
    
    trainProfile.mean{r} = meanP;
    trainProfile.covariance{r} = covP; 
end

save('trainProfile.mat','trainProfile');

end