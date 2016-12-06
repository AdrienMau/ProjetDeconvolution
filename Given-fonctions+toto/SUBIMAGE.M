function s = subimage (a,ix,iy,par)
%------------------------------------------------------------
% GETSUB.M
%
% Call: s = subimage (a,ix,iy,par)
%
%       a     ... Datamatrix
%	ix,iy ... image-position
%       par   ... [sx,sy,nx,ny] as returned from PMISREAD
%
% author: ts
% version: <01.00> from <950928.0000>
%----------------------------------------------------------------
if nargin<4, help subimage, return, end
global BORDER

nx = par(1)/par(3);
ny = par(2)/par(4);

if ix<1 | ix>par(3) | iy<1 | iy>par(4)
  disp 'parameter out of bounds'
  return
end

s = a ((iy-1)*ny+1:iy*ny-BORDER,(ix-1)*nx+1:ix*nx-BORDER);
