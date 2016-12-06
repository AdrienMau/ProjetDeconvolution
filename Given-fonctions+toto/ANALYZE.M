function OutVec = analyze (file, NSeq, mode, Conf, InVec)
%--------------------------------------------------------
% ANALYZE.M
%
% analysis of fitted data
%
% function	OutVec = analyze (file, NSeq, mode, Conf, InVec)
%
% input:	file - filename
%               NSeq - length of a sequence
%               mode - {0,10}: pdf's, {1,11}: histograms,
%                      >=10 output to printer
%               conf - confidence interval for data
%                      ie points for conf*x<dx are rejected
%               InVec - matrix of size InVec(:,1:7) to which the
%                       result is appended
%    
% output:	graphical display of PDF's of width and intensity
%		OutVec - appended result to InVec with
%                        OutVec(1:12) : filename
%                        OutVec(13)   : # of peaks
%                        OutVec(14)   : # of peaks in 1.image(s)
%                        OutVec(15)   : max width
%                        OutVec(16)   : max dark
%                        OutVec(17)   : max intensity
%                        OutVec(18)   : mean intensity
%                        OutVec(19)   : # of traces
%                        OutVec(20)   : max length of traces
%                        OutVec(21)   : mean diffusion constant
%                        OutVec(22)   : max prob. diffusion constant
%                        OutVec(23)   : mean bleaching time
%
%
% date: 10.10.1994
% author: ts
% version: <02.00> from <950915.0000>
%--------------------------------------------------------
if nargin<1, help analyze, return, end
if nargin<3, mode=0; end
if nargin<4, Conf=[]; end

global MASCHINE
%---------------------------------------
%evaluate <file>.pk - the output of SEQFIND
if strcmp(MASCHINE(1:2),'AT')
  DoIt  = ['load pk\',file,'.pk']
  set (gca,'FontSize',8)
elseif strcmp(MASCHINE(1:2),'PC')
  DoIt  = ['load pk\',file,'.pk']
  set (gca,'FontSize',8)
else
  DoIt  = ['load ',file,'.pk']
end
eval (DoIt)
ind = find(file=='.');
FName = file(1:ind(1)-1);
A = eval(FName);

%cancel points out of the confidence interval
A = clearpk (A,Conf,1);
if length(A)<=0
  PeaksFound = 0
  return
end
if nargin<2
  NSeq = max(A(:,1));
end
PeaksFound = length(A(:,1))
ind = find (rem(A(:,1),NSeq)==1);
FirstPeaksFound = length(ind)

%get the width, and intensity information
W     = A(:,4);
dW    = A(:,9);
Dark  = A(:,6);
dDark = A(:,11);
%I     = pi / 4 / log(2) * A(:,5) .* W.^2;
%dI    = sqrt((A(:,10)./A(:,5)).^2 + (2*dW./W).^2) .* I;
I     = A(:,5);
dI    = A(:,10);

%width statistics
[x,p] = pdf_old (W,dW,0,5);
WidthMax = x(find(p==max(p)))
clg, subplot(321)
plot (x,p)
xlabel('peak-width FWHM (pxl)'), ylabel('rho(w) (1/pxl)')
title(file)
txt = axis; text(5,0.9*txt(4),sprintf('Wmax=%4.2f',WidthMax))

%dark statistics
if rem(mode,10)==0
  [x,p] = pdf_old (Dark,dDark,-5,+5);
  subplot(321), plot (x,p)
else
  x=[max(min(Dark),-5):(min(max(Dark),+5)-max(min(Dark),-5))/sqrt(length(Dark)):...
     min(max(Dark),+5)];
  p = hist(Dark,x);
  subplot(321), stairs(x,p);
end
DarkMax = x(find(p==max(p)))
xlabel('dark-rate (1/pxl)'), ylabel('rho(d) (pxl)')
title(file)
txt = axis; text(5,0.9*txt(4),sprintf('dmax=%4.2f',DarkMax))

%intensity statistics
IntensityMean = mean (I)
DarkMean = mean (A(:,6))
if rem(mode,10)==0
  [x,p] = pdf_old (I,dI,0,1000);
  subplot(322), plot (x,p)
else
  x=[max(min(I),0):(min(max(I),1000)-max(min(I),0))/sqrt(length(I)):...
     min(max(I),1000)];
  p = hist(I,x);
  subplot(322), stairs(x,p);
end
IntensityMax = x(find(p==max(p)))
xlabel('peak-intensity (cnt)'), ylabel('rho(Ip) (1/cnt)')
txt = axis; text(500,0.9*txt(4),sprintf('Imax =%3d',fix(IntensityMax)))
txt = axis; text(500,0.8*txt(4),sprintf('<I>  =%3d',fix(IntensityMean)))
txt = axis; text(500,0.7*txt(4),sprintf('Idark=%3d',fix(DarkMean)))

pause(1)
%-------------------------------------------------------------------
%now <file>.trc  -  output of SEQTRACE
if strcmp(MASCHINE(1:2),'AT')
  DoIt  = ['load trc\',file]
elseif strcmp(MASCHINE(1:2),'PC')
  DoIt  = ['load trc\',file,'.trc']
else
  DoIt  = ['load ',file,'.trc']
end
eval (DoIt)
A = eval(FName);
NoTrace = max(A(:,1))
TrcLen  = ones(1,PeaksFound-size(A,1));

subplot(323)
axis ([min(A(:,3)),max(A(:,3)),-max(A(:,4)),-min(A(:,4))])
for itrc=1:NoTrace
  ind = find (A(:,1)==itrc);
  if length(ind)>0
    tl  = length(A(ind,1));
    if (size(A,2)<5)
      TrcLen = [TrcLen,A(ind(tl),2)-A(ind(1),2)+1];
    else
      if (A(ind(tl),5)==-1) | (A(ind(tl),2)-A(ind(1),2)+1==NSeq)
        TrcLen = [TrcLen,A(ind(tl),2)-A(ind(1),2)+1];
      end
    end
    plot (A(ind,3), -A(ind,4),A(ind,3), -A(ind,4),'ro')
    hold on
  end
end
hold off
axis ('normal')
xlabel ('X-position (pxl)'), ylabel('-Y-position (pxl)')

%plot histogram of trace-lengths and calulation of bleaching time
subplot(324)
MaxTrc = max(TrcLen);
HistTrcLen = hist (TrcLen,MaxTrc);
ind = find (HistTrcLen>0);
if length(ind)>1
  ind = ind(2:length(ind));
  tBleach = (1:MaxTrc);
  tBleach = tBleach(ind) ./ log(HistTrcLen(1)./HistTrcLen(ind));
  std_tBleach=std(tBleach)
  tBleach = mean(tBleach)
else
  tBleach = 0;
end

stairs ([HistTrcLen,0]);
xlabel ('length of trace (pxl)'), ylabel ('occurrence');
txt = axis; text(0.65*txt(2),0.9*txt(4),sprintf(' N=%4d',PeaksFound))
txt = axis; text(0.65*txt(2),0.8*txt(4),sprintf('N1=%3d',FirstPeaksFound))
txt = axis; text(0.65*txt(2),0.2*txt(4),sprintf('tB=%4.2f',tBleach))
txt = axis; text(0.65*txt(2),0.1*txt(4),sprintf('+- %4.2f',std_tBleach))

pause(1)
%-------------------------------------------------------------------
%now <file>.msd  -  output of SEQMSD
if strcmp(MASCHINE(1:2),'AT')
  DoIt  = ['load msd\',file]
elseif strcmp(MASCHINE(1:2),'PC')
  DoIt  = ['load msd\',file,'.msd']
else
  DoIt  = ['load ',file,'.msd']
end
eval (DoIt)
A = eval(FName);

%statistics of the diffusion constant
%ind   = find (A(:,3)~=A(:,4));
ind = 1:size(A,1);
Diff  = A(ind,3) ./ A(ind,2) / 4;
dDiff = A(ind,4) ./ A(ind,2) / 4;
MaxTrc = max(A(:,2)) 
MeanD  = mean(Diff)
if rem(mode,10)==0
  [x,p] = pdf_old (Diff,dDiff,0);
  subplot(325), plot (x,p)
else
  x = [max(min(Diff),0):(max(Diff)-max(min(Diff),0))/sqrt(length(Diff)):...
       max(Diff)];
  p = hist(Diff,x);
  subplot(325), stairs(x,p);
end
xlabel('diffusion constant (pxl/lag'), ylabel('rho(D) (lag/pxl)')
txt = axis; text(0.5*txt(2),0.8*txt(4),sprintf(' <D>=%4.2f',MeanD))

%linear MSD-plot
subplot(326)
axis ([0,max(A(:,2)),0,max(A(:,3))])
for itrc=1:max(A(:,1))
  if length(ind)>0
    ind = find (A(:,1)==itrc);
    plot ([0;A(ind,2)], [0;A(ind,3)])
    hold on
  end
end
hold off
axis ('normal')
xlabel ('time lag'), ylabel('MSD (pxl)')
txt = axis; text(0.65*txt(2),0.2*txt(4),sprintf('#trc=%3d',NoTrace))

pause(1)
%---------------------------------------------------------
%report result
if nargin>4
  OutVec=[PeaksFound,FirstPeaksFound,WidthMax,DarkMax,IntensityMax, ...
          IntensityMean,NoTrace,MaxTrc,MeanD,tBleach];
  OutVec=[InVec;abs(file),zeros(1,12-length(file)),OutVec];
end
if ((strcmp(MASCHINE(1:2),'AT')|strcmp(MASCHINE(1:2),'PC')) & mode>=10)
  set (gcf,'PaperType','A4')
  print
  pause (20)
end
