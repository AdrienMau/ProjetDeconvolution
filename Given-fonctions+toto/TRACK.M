function [Z,C] = track (X1,X2,D,xmax,ymax,TOpts,OMode)
%---------------------------------------------------------------------
% TRACK.M
%
% Call: [Z,C] = track (X1,X2,D,xmax,ymax,TOpts,OMode)
%
% output:    Z  ... Adjacent matrix
%            C  ... Weight matrix
%
% input:    X1      ...     positions in first image (Nx2)
%           X2      ...     positions in second image (Mx2)
%           D       ...     diffusion constant [pxl/lag]
%           xmax    ...     y-size of image [pxl]
%           ymax    ...     y-size of image [pxl]
%           TOpts   ... (o) tracking options
%           OMode   ... (o) output on/off (1/0)
%
%
% form of the matrix exp(C):
%
%           (p11 p12  ...   p1n2 | p1b  0  ...    )
%           (p21 p22  ...   p2n2 |  0  p2b  0 ... )
%           (        .           |       .        )
%           (        .           |       .        )
%           (pn11 pn12 ... pn1n2 |    ...  0  pn1b)
%           (--------------------|----------------)
%           (p1r 0 ...           |   1   0  ...   )
%           (0   p2r 0 ...       |   0   1   0 .. )
%           (        .           |       .        )
%           (        .           |       .        )
%           (         ... 0 pn2r |      ...  0  1 )
%
%  with probapilities
%       pIJ ... molecule I in image 1 corresponds molecule J in image 2
%               I=[1:n1], J=[1:n2]
%       pIb ... molecule I in image 1 disappears
%       pIr ... molecule I in image 2 appears
%
%
% author: Baumgartner Werner, modified ts 
% version: <01.12> from <950723.0000>
%__________________________________________________________
if nargin<5, help track, return, end
if nargin<6, TOpts=[]; end
if nargin<7, OMode=0; end

% initialize
[dummy,dummy,TOpts]=fitopt([],[],TOpts);
bleach  = TOpts(1);
no_mol  = TOpts(3);
recover = TOpts(4);
n1 = size(X1,1);
n2 = size(X2,1);
n  = n1+n2;
kb = 1/(bleach*2*D+eps);
kr = 1/(recover*2*D+eps);
cm = no_mol/(xmax*ymax);
C  = zeros(n,n);
ef = 1/(4*D+eps);
pf = sqrt(ef/pi);

%are one or both of the images empty?
if (n==0)
  Z=ones(1,3); C=[];
  return
end
if (n1==0)
  Z = [[n2+1:2*n2]',[1:n2]',ones(n2,1)];
  C = [];
  return
end
if (n2==0)
  Z = [[1:n1]',[n1+1:2*n1]',ones(n1,1)];
  C = [];
  return
end

%all possible combinations
for i=1:n1
  for j=1:n2
    C(i,j) = pf * exp(-ef*sum((X1(i,:)-X2(j,:)).^2));
  end;
end;

% disappearing molecules
%h = 1/(2*sqrt(D)+eps);
%for i=1:n1
%  k1 = erf (h*(xmax-X1(i,1)));
%  k2 = erf (h*X1(i,1));
%  k3 = erf (h*(ymax-X1(i,2)));
%  k4 = erf (h*X1(i,2));
%  C(i,n2+i) = kb + (1-.25*(k1+k2)*(k3+k4));
%end;
if (n2<n)
  dmin = min([X1';xmax-X1(:,1)';ymax-X1(:,2)']);
  C(1:n1,n2+1:n) = (kb+pf*exp(-ef*dmin.^2))'*ones(1,n-n2);
end

% appearing molecules
%for i=1:n2
%  k1 = erf (h*(xmax-X2(i,1)));
%  k2 = erf (h*X2(i,1));
%  k3 = erf (h*(ymax-X2(i,2)));
%  k4 = erf (h*X2(i,2));
%  C(n1+i,i) = kr + cm*(1-.25*(k1+k2)*(k3+k4));
%end;
if (n1<n)
  dmin = min([X2';xmax-X2(:,1)';ymax-X2(:,2)']);
  C(n1+1:n,1:n2) = ones(n-n1,1)*(kr+cm*pf*exp(-ef*dmin.^2));
end

%fill up lower matrix
if (n1<n & n2<n)
  m = min(n-n1,n-n2);
  C(n1+1:n1+m,n2+1:n2+m) = diag(ones(m,1));
end

%sort out the best combination
Z  = vogel(-log(C+eps));
Z1 = [Z,C(size(Z,1)*(Z(:,2)-1)+Z(:,1))];
p1 = sum(log(Z1(:,3)+eps));

Z  = vogel(-log(C'+eps));
Z  = [Z(:,2),Z(:,1),C(size(Z,1)*(Z(:,1)-1)+Z(:,2))];
p2 = sum(log(Z(:,3)+eps));

if (p2<p1)
  Z = Z1;
end
if OMode>0, [p1,p2], end
