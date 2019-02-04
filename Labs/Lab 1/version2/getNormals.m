function norms = getNormals(X)
% function to compute norm points of landmarks
% input: 2nx1 column vector
% output: nx2

% usage
% Norms = getNorm(T);
% plot([Tx-20*Norms(:,1) Tx+20*Norms(:,1)]',[Ty-20*Norms(:,2) Ty+20*Norms(:,2)]');
% where -20 and +20 represent the norm range  

% division to x and y components
Tx = X(1:size(X,1)/2);
Ty = X((size(X,1)/2) + 1:end);
       
% number of points
npts = size(X,1)/2;
          
for i = 1 : npts
  if i == 1
       vX(i,:) = Tx(i) - Ty(i+1);
       vY(i,:) = Tx(i) - Ty(i+1);
  elseif (i <=npts-1)
       vX(i,:) = Tx(i-1)- Tx(i+1);
       vY(i,:) = Ty(i-1)- Ty(i+1);
  elseif (i == npts)
       vX(i,:) = Tx(i)- Tx(i-1);
       vY(i,:) = Ty(i)- Ty(i-1);
  end
end    

% magnitude 
mag = sqrt(vX.^2 + vY.^2);
       
% norm in x and y directions
nX = -vY./mag;
nY =  vX./mag;

norms =[nX,nY];  
end