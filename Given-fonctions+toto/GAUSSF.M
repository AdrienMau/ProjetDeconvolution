function f = gaussf (p,maxX,maxY)
%----------------------------------------------------------
% GAUSSF.M
% calculates a 2D-Gaussian in the interval [1,maxX][1,maxY]
%
% call: f = gaussf (p[5],maxX, maxY)
% with: p(1):       X-position
%       p(2):       Y-position
%       p(3):       width (FWHM)
%       p(4):       area
%       p(5):       offset
%       maxX, maxY: maximal region in X- Y-direction
%
% author: wb & ts
% version: <01.00> from <950125.0000>
%-----------------------------------------------------------
%prepare X- Y-vectors
efac=4*log(2)/p(3)^2;
xpos=1-p(1):maxX-p(1);
ypos=1-p(2):maxY-p(2);

%calculate the distance-matrix
for i=1:maxY,
  posx(i,:)=xpos(1,:);
end;
for i=1:maxX,
  posy(:,i)=ypos(1,:)';
end;
r=posx.^2+posy.^2;

%calculate the Gaussian in one call
f=p(5)+efac/pi*p(4)*exp(-efac*r);
