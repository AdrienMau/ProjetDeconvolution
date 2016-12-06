function OutVec = analyze (file, Conf, NSeq, InVec)
%--------------------------------------------------------
% ANALYZE.M
%
% analysis of fitted data
%
% function	OutVec = analyze (file, Conf, NSeq, InVec)
%
% input:	file - filename
%		conf - confidence interval for data
%		       ie points for conf*x<dx are rejected
%               NSeq - length of a sequence
%               InVec - matrix of size InVec(:,1:7) to which the
%                       result is appended
%    
% output:	graphical display of PDF's of width and intensity
%		OutVec - appended result to InVec with
%                        OutVec(1:12) : filename
%                        OutVec(13)   : # of peaks
%                        OutVec(14)   : # of peaks in 1.image(s)
%                        OutVec(15)   : mean width
%                        OutVec(16)   : max intensity
%                        OutVec(17)   : mean intensity
%                        OutVec(18)   : # of traces
%                        OutVec(19)   : max length of traces
%                        OutVec(20)   : mean diffusion constant
%                        OutVec(21)   : max prob. diffusion constant
%                        OutVec(22)   : mean bleaching time
%--------------------------------------------------------
if nargin<1, help analyze, return, end
if nargin<2, Conf=[]; end

global MASCHINE
%---------------------------------------
%evaluate <file>.pk - the output of SEQFIND
if 0==1 
if strcmp(MASCHINE,'convex')
  DoIt  = ['load ',file,'.pk']
else
  DoIt  = ['load pk\',file]
  set (gca,'FontSize',8)
end
FName = file(1:find(file=='.')-1);
eval (DoIt)
A = eval(FName);

%cancel points out of the confidence interval
A = clearpk (A,Conf,1);
if length(A)<=0
  PeaksFound = 0
  return
end
PeaksFound = length(A(:,1))
if nargin>2
  ind = find (rem(A(:,1),NSeq)==1);
  if length(ind)>0
    FirstPeaksFound = length(A(ind,1))
  else
    FirstPeaksFound = 0
  end
end

%get the width, and intensity information
W  = A(:,4);
dW = A(:,9);
Dark  = A(:,6);
dDark = A(:,11);
I  = pi / 4 / log(2) * A(:,5) .* W.^2;
dI = sqrt((A(:,10)./A(:,5)).^2 + (2*dW./W).^2) .* I;

%width statistics
[x,p] = pdf (W,dW,0,5);
WidthMax = x(find(p==max(p)))
%clg, subplot(321)
%plot (x,p)
%xlabel('peak-width FWHM (pxl)'), ylabel('rho(w) (1/pxl)')
%title(file)
%txt = axis; text(5,0.9*txt(4),sprintf('Wmax=%4.2f',WidthMax))


%Dark statistics
[x,p] = pdf (Dark,dDark,-5,+5);
DarkMax = x(find(p==max(p)))
clg, subplot(321)
plot (x,p)
xlabel('Dark rate (cnts/pxl)'), ylabel('rho(w) (pxl/cnts)')
title(file)
txt = axis; text(5,0.9*txt(4),sprintf('Darkmax=%4.1f',DarkMax))

%intensity statistics
[x,p] = pdf (I,dI,-100,1000);

IntensityMax = x(find(p==max(p)))
IntensityMean = mean (I)
DarkMean = mean (A(:,6))
subplot(322), plot (x,p)
% stairs(0:50:2000,hist(I,25:50:2025))
xlabel('peak-intensity (cnt)'), ylabel('rho(Ip) (1/cnt)')
txt = axis; text(500,0.9*txt(4),sprintf('Imax =%3d',fix(IntensityMax)))
txt = axis; text(500,0.8*txt(4),sprintf('<I>  =%3d',fix(IntensityMean)))
txt = axis; text(500,0.7*txt(4),sprintf('Idark=%3d',fix(DarkMean)))
end

pause(1)
%-------------------------------------------------------------------
%now <file>.trc  -  output of SEQTRACE
if strcmp(MASCHINE,'convex')
  DoIt  = ['load ',file,'.trc']
else
  DoIt  = ['load trc.dat']
end
FName = file(1:find(file=='.')-1);
eval (DoIt)
A = trc;
NoTrace = max(A(:,1))
TrcLen  = ones(1,PeaksFound-size(A,1));

subplot(323)
axis ([min(A(:,3)),max(A(:,3)),-max(A(:,4)),-min(A(:,4))])
for itrc=1:NoTrace
  ind    = find (A(:,1)==itrc);
  TrcLen = [TrcLen,A(ind(length(ind)),2)-A(ind(1),2)];
  plot (A(ind,3), -A(ind,4),A(ind,3), -A(ind,4),'ro')
  hold on
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
if strcmp(MASCHINE,'convex')
  DoIt  = ['load ',file,'.msd']
else
  DoIt  = ['load msd1.dat']
end
FName = file(1:find(file=='.')-1);
eval (DoIt)
A = msd1

%statistics of the diffusion constant
ind = find (A(:,3)~=A(:,4));
x = A(ind,3) ./ A(ind,2) / 4;
p = A(ind,4) ./ A(ind,2) / 4;
%subplot(325),stairs(0:0.4:6,hist(x,0.2:0.4:6.2))
[x,p] = pdf (x,p,0);
MaxTrc = max(A(:,2)) 
MeanD = mean(A(:,3)./A(:,2)/4)
MaxD  = x(find(p==max(p)))
subplot(325), plot (x,p)
xlabel('diffusion constant (pxl/lag'), ylabel('rho(D) (lag/pxl)')
txt = axis; text(0.5*txt(2),0.9*txt(4),sprintf('Dmax=%4.2f',MaxD))
txt = axis; text(0.5*txt(2),0.8*txt(4),sprintf(' <D>=%4.2f',MeanD))

%linear MSD-plot
subplot(326)
axis ([0,max(A(:,2)),0,max(A(:,3))])
for itrc=1:max(A(:,1))
  ind = find (A(:,1)==itrc);
  plot ([0;A(ind,2)], [0;A(ind,3)])
  hold on
end
hold off
axis ('normal')
xlabel ('time lag'), ylabel('MSD (pxl)')
txt = axis; text(0.65*txt(2),0.2*txt(4),sprintf('#trc=%3d',NoTrace))

pause(1)
%---------------------------------------------------------
%report result
if nargin>3
  OutVec=[PeaksFound,FirstPeaksFound,WidthMax,IntensityMax,IntensityMean,NoTrace,MaxTrc,MeanD,MaxD,tBleach];
  OutVec=[InVec;abs(file),zeros(1,12-length(file)),OutVec];
  if strcmp(MASCHINE,'at')
    set (gcf,'PaperType','A4')
    print
    pause (20)
  end
end
