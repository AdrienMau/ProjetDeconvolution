function   subimg = getsub (ix,iy,ip,img,par)
%------------------------------------------------------------
% GETSUB.M  -  returns subimage (ix,iy,ip) from image
%
% Call: Subimage = getsub (ix,iy,image,parameter)
%       Subimage = getsub (ix,iy,ip,image,parameter)
%       ix,iy     ... subimage (ix,iy)
%       ip        ... polarization ip in subimage (ix,iy)
%       image     ... Datamatrix
%       parameter ... [sx,sy,nx,ny]
%     
%       parameter: (see also PMISREAD)
%              sx ... Imagesize in x- direction
%              sy ... -----"-----  y- direction
%              nx ... Number of subimages in x- direction
%              ny ... Number of subimages in y- direction
%              np ... Number of polarizations
%
%
% date: 14.2.1998
% author: ts
% version: <02.00> from <000330.0000>
%----------------------------------------------------------------
if nargin<4, help getsub, return, end
if nargin<5, par=img; img=ip; ip=0; end
global BORDER

% check input
if length(par)<5, par(5)=1; end
if (ix<1)|(iy<1) | (ix>par(3))|(iy>par(4))|(ip>par(5))
  disp 'image index out of range'
  subimg = [];
  return
end

% return subimage
subimg = img((iy-1)*par(2)/par(4)+1:iy*par(2)/par(4)-BORDER, ...
   			 (ix-1)*par(1)/par(3)+1:ix*par(1)/par(3)-BORDER);
          
% cut out the polarizations          
if ip>0
   subimg = subimg (:,(ip-1)*par(1)/par(3)/par(5)+1:ip*par(1)/par(3)/par(5));
end