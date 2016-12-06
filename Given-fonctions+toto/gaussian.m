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

% - Version information
% version: <01.00> from <950125.0000>
%			  <01.01> from <000804.0000> by WJ & GAB
%				   vectorized loops
%			  <01.02> from <000807.1000> by GAB
%					replaced n^2 exponentials with 2n exponentials and n^2 multiplications
%-----------------------------------------------------------
%prepare X- Y-vectors

efac=4*log(2)/p(3)^2;
%xpos=-efac*( (1-p(1):maxX-p(1)).^2 );
xpos=efac/pi*p(4)*exp(-efac*( (1-p(1):maxX-p(1)).^2 ));
%ypos=1-p(2):maxY-p(2);
%ypos=-efac*( ((1-p(2):maxY-p(2))').^2 );
ypos=exp(-efac*( ((1-p(2):maxY-p(2))').^2 ));

%calculate the distance-matrix - version 1 (slooow)
%for i=1:maxY,
%  posx(i,:)=xpos(1,:);
%end;
%for i=1:maxX,
%  posy(:,i)=ypos(1,:)';
%end;

%calculate the distance-matrix - version 2 (5x faster)
%posx=ones(length(ypos),1)*xpos;
%posy=ypos'*ones(1,length(xpos));


%calculate the distance-matrix - version 4 - gerhard's version
posx=xpos(ones(length(ypos),1),:);
posy=ypos(:,ones(1,length(xpos)));

%calculate the Gaussian in one call
%f=p(5)+efac/pi*p(4)*exp(posx+posy);
f=p(5)+(posx.*posy);

%end modifications

%free memory
%clear r posy posx ypos xpos,
% I don't think memory is that much of a problem ...



