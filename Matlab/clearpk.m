function  PeaksO = clearpk (PeaksI,Conf,ClrMode,pkwmax)
%---------------------------------------------------------------------------
% CLEARPK.M
%
% usage:  PeaksOut = clearpk (PeaksIn, Conf, ClrMode)
%
% input:        PeaksIn  - Matrix of the fitting result from the program
%                          FINDPEAK
%               Conf     - [ChiTest, NTest, FTest]
%                          confidence interval for the fitting parameter:
%                          the value has to be larger than confI times its
%                          standard deviation
%               ClrMode  - mode for rejection of peaks
%                          0 : only double peaks are canceled
%                          1 : according to statistical tests (default)
%                          2 : according to confidence intervalls
%                          3 : only peaks within limits
%
% output:       PeaksOut - Matrix of cleared peaks
%
%
% date: 15.7.1994
% author: ts
% version: <01.20> from <940930.0000>
%---------------------------------------------------------------------------
if nargin<1, help clearpk, return, end,
if nargin<2, Conf=[]; end
if nargin<3, ClrMode=1; end
if nargin<4, pkwmax=4; end
if length(PeaksI)==0, PeaksO=[]; return, end

dind  = [];
[dummy,Conf] = fitopt([],Conf);
Cconf = Conf(1);
Nconf = Conf(2);
Fconf = Conf(3);
conf  = Conf(1);
WLim  = [1,pkwmax];
if Cconf==0 & Nconf==0 & Fconf==0
  ClrMode = 0;
end

ClrMode=3;%%%%%%%%%%%%%%%%%%%%%%%%ajouté juin 2012
if size (PeaksI,2)<15 & ClrMode==1
  ClrMode = 2
end
%------------------------------------------------------
%kill all peaks according to ClrMode
%statistical test
if ClrMode==1
  cind = find((PeaksI(:,13)>=Cconf) & ...
	      (PeaksI(:,14)>=Nconf) & ...
	      (PeaksI(:,15)>=Fconf));
end

%confidence interval for paramter
if ClrMode==2
  cind = find((conf*PeaksI(:,4)>=PeaksI(:,9)) & ...
	      (conf*PeaksI(:,5)>=PeaksI(:,10)));
end

%values of parameter
if ClrMode==3
  cind = find (PeaksI(:,4)>=WLim(1) & PeaksI(:,4)<=WLim(2));
  disp(['On vire les pics de largeur inférieure à 1 pxl et supérieure à ' ,num2str(pkwmax), ' pxl.']);
end

if ClrMode>0
  PeaksO = PeaksI(cind,:);
else
  PeaksO = PeaksI;
end

if length(PeaksO)==0, return, end
%---------------------------------------------------------
%kill all peaks wich are double
I1 = min (PeaksO(:,1));
In = max (PeaksO(:,1));

for I=I1:In
  iind  = find(PeaksO(:,1)==I);
  if length(iind)>0
    dind  = [dind,iind(1)];
    if length(iind)>1
      for Ipk=length(iind):-1:2
	Xdist = PeaksO(iind(1:Ipk-1),2) - PeaksO(iind(Ipk),2);
	Ydist = PeaksO(iind(1:Ipk-1),3) - PeaksO(iind(Ipk),3);
	dist  = Xdist.^2 + Ydist.^2;
	if min(dist)>PeaksO(iind(Ipk),4)^2
	  dind = [dind,iind(Ipk)];
	end
      end
    end
  end
end

PeaksO = PeaksO(dind,:);
