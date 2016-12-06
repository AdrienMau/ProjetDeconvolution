function f = airy(p,maxX,maxY)
%----------------------------------------------------------
% AIRY.M
% calculates a 2D-Airy function in the interval [1,maxX][1,maxY]
%
% call: f=airy(p(5),maxX, maxY)
% with: p(1):       X-position
%       p(2):       Y-position
%       p(3):       width (FWHM)
%       p(4):       heigth
%       p(5):       offset
%       maxX, maxY: maximal region in X- Y-direction
%
% author: ts
% version: <01.00> from <941029.0000>
%-----------------------------------------------------------
%prepare X- Y-vectors
xfac = abs(p(3)) / 7.66052;
xpos = 1-p(1) : maxX-p(1);
ypos = 1-p(2) : maxY-p(2);

%calculate the distance-matrix
for i=1:maxY,
  posx(i,:)=xpos(1,:);
end;
for i=1:maxX,
  posy(:,i)=ypos(1,:)';
end;
r = sqrt (posx.^2+posy.^2);
r = (r+eps*(r==0)) / xfac;

%calculate the Gaussian in one call
f = p(5) + 4*p(4) * (besselj(1,r)./r).^2;

