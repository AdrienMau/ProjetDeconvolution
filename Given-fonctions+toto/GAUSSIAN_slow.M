function f = gaussian(p,maxX,maxY)
%----------------------------------------------------------
% GAUSSIANI.M
% calculates a 2D-Gaussian in the interval [1,maxX][1,maxY]
%
% call: f=gaussiani(p(5),maxX, maxY)
% with: p(1):       X-position
%       p(2):       Y-position
%       p(3):       width (FWHM)
%       p(4):       area
%       p(5):       offset
%       maxX, maxY: maximal region in X- Y-direction
%
% author: wb & ts
% version: <01.00> from <950125.0000>
%			  <01.01> from <000804.0000> by WJ & GAB
%-----------------------------------------------------------
%prepare X- Y-vectors

efac=4*log(2)/p(3)^2;
xpos=1-p(1):maxX-p(1);
ypos=1-p(2):maxY-p(2);

%** modification by WJ & GAB
%calculate the distance-matrix
for i=1:maxY,
  posx(i,:)=xpos(1,:);
end;
for i=1:maxX,
  posy(:,i)=ypos(1,:)';
end;
%posx=ones(length(xpos),1)*xpos;
%posy=ypos'*ones(1,length(ypos));
%** end modification

r=posx.^2+posy.^2;

%calculate the Gaussian in one call
f=p(5)+efac/pi*p(4)*exp(-efac*r);

%free memory
clear r posy posx ypos xpos,



