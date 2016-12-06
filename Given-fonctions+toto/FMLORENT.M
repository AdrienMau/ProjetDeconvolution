function f = fmlorent (x,y,p)
%----------------------------------------------------------
% FMLORENTZ.M
% calculates multiple Lorentians with parameter par
%
% usage:  f = fmlorent (x, [y,] p)
%
% input:  x       - calculate at these positions
%         y       - (in 2-D case)
%         p(n,4)  -          1-D              2-D
%               p(i,1)   - position       X-position
%               p(i,2)   - width (FWHM)   Y-position
%               p(i,3)   - maximum        width (FWHM)
%               p(i,4)   - -none-         maximum
%               p(n+1,1) - offset         offset
%
% date: 5.1.1996
% author: ts
% version: <01.00> from <960105.0000>
%-----------------------------------------------------------
if nargin<2, help fmlorent, return, end
if nargin<3, p=y; y=0; end

% prepare input
p = p';
p = p(:);
if nargin>2
  if rem(length(p),4)~=0 | length(p)==4
    p = [p;zeros(4-rem(length(p),4),1)];
  end
  mg = length(p)/4 - 1;
  p  = reshape (p,4,mg+1)';
else
  if rem(length(p),3)~=0 | length(p)==3
    p = [p;zeros(3-rem(length(p),3),1)];
  end
  mg = length(p)/3 - 1;
  p  = reshape (p,3,mg+1)';
  p  = [p(:,1),zeros(size(p,1),1),p(:,2:3)];
end

% -------------------------------------------
% add all Lorentzians
f = florentz (x,y,[p(1,:),0]);
if mg>1
  for ig=2:mg
    f = f + florentz (x,y,[p(ig,:),0]);
  end
end
%--------------------------------------------
% add offest
f = f + p(mg+1,1);
if nargin<3
  f = reshape (f,size(x,1),size(x,2));
end

