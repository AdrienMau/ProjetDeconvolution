function Gauss = mcgauss (par,nx,ny)
%----------------------------------------------------------
% MCGAUSS.M
% calculation of a 2D-Gaussian by Mont-Carlo
%
% usage:   Gauss = mcgauss (par,nx,ny)
%
% input:	par - parameter of Gaussian
%		      p(1) x-position
%		      p(2) x-position
%		      p(3) width (FWHM)
%		      p(4) heigth
%		      p(5) offset
%		nx  - size of the resulting image
%		ny
%
% output:	Gauss(ny,nx) - the Gaussian
%			       !! the output is an integer-field !!
%
% date: 25.4.1995
% author: ts
% version: <01.00> from <950425.0000>
%------------------------------------------------------------
if nargin<2, help mcgauss, end
if nargin<3, ny=1; end

%internal parameter
sigma   = par(3) / (2*sqrt(2*log(2)));
NPhoton = pi/(4*log(2)) * par(4) * par(3)^2;
px      = par(1);
py      = par(2);
sigmaX  = sigma;
sigmaY  = sigma;
Gauss   = round (par(5)*ones(ny,nx));

%1-D case
if nx<=1
  nx      = 1;
  px      = 1;
  sigmaX  = 0;
  NPhoton = sqrt (NPhoton*par(4));
end
if ny<=1
  ny      = 1;
  py      = 1;
  sigmaY  = 0;
  NPhoton = sqrt (NPhoton*par(4));
end

%now start sampling
for j=1:NPhoton
  hx = round (px+sigmaX*randn);
  hy = round (py+sigmaY*randn);
  if hx>=1 & hx<=nx & hy>=1 & hy<=ny
    Gauss(hy,hx) = Gauss(hy,hx) + 1;
  end
end
  