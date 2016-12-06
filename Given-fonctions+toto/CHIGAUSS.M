function f = chigauss(p,y,s,o)
%--------------------------------------------------------------
% CHIGAUSS.M
% calculates the chi-squared values for the given 2D-Gaussian
% and the input field. The errors of the data points are assumed
% to be statistically distributed.
%
% Call: f=chigauss(p,y,[s,[o]])
%
% Input: p(1): x- Coordinate
%        p(2): y- Coordinate
%        p(3): width (FWHM)
%        p(4): heigth
%        p(5): offset
%        y   : Inputmatrix
%        s   : standard-deviations (optional)
%        o   : option 0 : chisqare (optional)
%                     1 : absolute deviation
%
% Output: chi - depending on option
%
%
% author: wb & ts
% version: <01.10> from <940629.0000>
%--------------------------------------------------------------
% check for input parameter
if nargin<2, help chigauss, return, end
if nargin<3, s=1; end
if nargin<4, o=0; end

%calculate gaussian
[maxY,maxX]=size(y);
g=gaussian(p,maxX,maxY);

%calculte Chi
if o==1
  f = sum(sum(abs(y-g)./s));
else
  f = sum(sum(((y-g)./s).^2));
end
