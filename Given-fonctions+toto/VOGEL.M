function Z = vogel (C,posi,posj)
%-----------------------------------------
% VOGEL.M
%
% Call: Z = vogel(C)
%
%       Z ... connection-matrix (2xN)
%       C ... weight-matrix (NxN)
%
% Baumgartner Werner
% version: <01.00> from <950308.0000>
%_________________________________________
if nargin<1, help vogel, return, end
n = size(C,2);

%start recursion
if nargin==1
  if size(C,1)~=n
    error('Matrix must be quadratic.')
  end
  posi = 1:length(C);
  posj = posi;
end;

%end recursion
if n==1
  Z = [posi,posj];
  return
end

%--------------------------------------
%find minima in each row
m = min(C');
U = C - (ones(n,1)*m)';
for i=1:n
  ind         = find(C(i,:)==m(i));
  U(i,ind(1)) = inf;
end;

%find row/col maximal deviation to the next
mm     = min(U');
maxmin = max(mm);
i = find(mm==maxmin);
i = i(1);
j = find(U(i,:)==inf);
j = j(1);

%prepare for next call
Cz      = C;
Cz(i,:) = [];
Cz(:,j) = [];
pic     = posi;
pjc     = posj;
pic(i)  = [];
pjc(j)  = [];

%next call
Z = [posi(i),posj(j);vogel(Cz,pic,pjc)];
