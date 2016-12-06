function ROut = checktst (image, RIn, noise, ConfLimit)
%---------------------------------------------------
% CHECKTST.M
%
% special check and correction of the fittest routine
%
% author: wb & ts
% version: <02.00> from <940930.0000>
%----------------------------------------------------
if nargin<3, help checktst, return, end
if nargin<4, ConfLimit=[]; end
if length(RIn)==0, ROut=[]; return, end

%calculate parameter
[dummy,ConfLimit] = fitopt ([],ConfLimit);
IXsize = size(image,2);
IYsize = size(image,1);
SubSz  = 4;

%clear from double peaks and find peaks for which the
%exponential test is positive
ROut = clearpk ([ones(size(RIn,1),1),RIn],[],0);
ROut = ROut(:,2:size(ROut,2));
ind  = find (ROut(:,12)>=ConfLimit(1));
NoPk = length(ind);
if NoPk==0, return, end

%from these calculate the resultant image
FitImage = mean(ROut(ind,5)) * zeros(IYsize,IXsize);
for ipk=1:NoPk
  FitImage = FitImage + gaussian([ROut(ind(ipk),1:4),0],IXsize,IYsize);
end
  
%recalculate the tests
for ipk=1:NoPk
  ixl = max (1     ,round(ROut(ind(ipk),1)-SubSz));
  ixh = min (IXsize,round(ROut(ind(ipk),1)+SubSz));
  iyl = max (1     ,round(ROut(ind(ipk),2)-SubSz));
  iyh = min (IYsize,round(ROut(ind(ipk),2)+SubSz));

  subim  = image(iyl:iyh,ixl:ixh);
  subfit = FitImage(iyl:iyh,ixl:ixh);
  test = fittest (subim,subfit,noise);
  ROut(ind(ipk),12) = test(1);
  ROut(ind(ipk),14) = test(3);
end


