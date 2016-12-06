function showpeak (file, NSeq, Xmax, Ymax, Conf)
%--------------------------------------------------------
% SHOWPEAK.M
%
% All found peaks are displayed and afterwards a complete 
% analysis of the fitted data is shown (ANALYZE)
%
%
% function	showpeak (file, NSeq, Xmax, Ymax, Conf)
%
% input:	file - filename
%               NSeq - length of an image in Y-direction
%               Xmax - maximal X-position
%               Ymax - maximal Y-position
%		Conf - confidence interval for data
%		       ie points for conf*x<dx are rejected
%
% output:	graphics and text
%
%
% date: 20.8.1994
% author: ts
% version: <01.00> from <940820.0000>
%--------------------------------------------------------
if nargin<2, help showpeak, disp('hit any key'), pause
             help analyzepk, return
end
if nargin<5, Conf=[]; end

global MASCHINE
nXImage = 3;
nYImage = 3;
NImage  = nXImage * nYImage;
%----------------------------------------------------------
%evalueate <file>.pk - the output of SEQFIND
if strcmp(MASCHINE,'convex')
  DoIt  = ['load ',file,'.pk']
else
  DoIt  = ['load pk\',file]
end
FName = file(1:find(file=='.')-1);
eval (DoIt)
A = eval(FName);
IIMax  = max(A(:,1));
Border = 1;

%cancel points out of the confidence interval
A = clearpk (A,Conf,1);

if length(A)<=0
  PeaksFound = 0
  return
end

PeaksFound = length(A(:,1))
Xmin = 0;
Ymin = 0;
if nargin<3
  Xmin = fix(min(A(:,2)));
  Xmax = ceil(max(A(:,2)));
end
if nargin<4
  Ymin = fix(min(A(:,3)));
  Ymax = ceil(max(A(:,3)));
end

%--------------------------------------------------------------------
%plot total image first  
subplot(111)
axis ('manual')
axis ([0,ceil(IIMax/NSeq),-NSeq,0])
axis;
xt = (A(:,2)-Xmin)/(Xmax-Xmin+Border) + fix(A(:,1)/NSeq);
yt = (A(:,3)-Ymin)/(Ymax-Ymin+Border) + (A(:,1)/NSeq-fix(A(:,1)/NSeq))*NSeq;
plot (xt,-yt,'*g')
xlabel ('X-image'), ylabel('- Y-image')
title (file), grid
disp ('hit any key'), pause

%------------------------------------------------------------------------
%loop through the images
ii=0;
for im=min(A(:,1)):max(A(:,1))
  ind = find (A(:,1)==im);
  if length(ind)>0
    PlotNo = nYImage*100+nXImage*10+rem(ii,NImage)+1; ii = ii+1; 
    subplot(PlotNo)
    plot(A(ind,2),-A(ind,3),'*g')
    axis([Xmin,Xmax,-Ymax,-Ymin]);
    title (['image ', num2str(im)])
    if PlotNo-nYImage*100-nXImage*10==NImage
      xlabel('X-position'); ylabel('-Y-position')
      pause
    end
  end
end
pause

%-------------------------------------------------------
%start complete analysis
axis ('auto'), hold off
analyze (file, Conf, NSeq)




