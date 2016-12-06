function h=peakcheck(filename, cutoffs)
% Peakcheck (filename, cutoffs)
% --
% reads peakfile <filename>  and
% removes all points not confiming to <cutoffs>.
% currently cutoffs consist of a rowvector [ RelavtiveError MaxCounts ]
% calculates means of peakwidth, darkrate and intensity and the means of the errors
% generates pdf's for peakwidth, darkrate and intensity 
% gives the maximum values for peakwidth, darkrate and intensity form pdf's
% calculates the minimal precision and lateral diffusion constant using these values
% Version 1.0 13/9/2000 by PL
% --

if nargin < 1
   help peakwidth
   return
end

if nargin < 3
   cutoffs = [1/3 1000];
	disp('Set default cutoff values 1/3 relErr & 1000 cntsMax');
  
	if nargin < 2
      till=1;
   	disp('Set default illumination 5ms');
   end
end

clear f;
clear sel;
cd pk
data=load(filename);
cd ..

sel = find(data(:,10)<(data(:,5)*cutoffs(1)) & data(:,5)> 0 & data(:,5)< cutoffs(2)) ;

h = data(sel,:);


%get the width, and intensity information
W     = h(:,4);
dW    = h(:,9);
Dark  = h(:,6);
dDark = h(:,11);
%I     = pi / 4 / log(2) * npkdata(:,5) .* W.^2;
%dI    = sqrt((npkdata(:,10)./npkdata(:,5)).^2 + (2*dW./W).^2) .* I;
I     = h(:,5);
dI    = h(:,10);

mW=mean(W)
dmW=std(W)/(sqrt(length(W)-1))
mDark=mean(Dark)
dmDark=std(Dark)/(sqrt(length(Dark)-1))
mI=mean(I)
dmI=std(I)/(sqrt(length(I)-1))


%width statistics
[x,p] = pdf_old (W,dW,0,5);
WidthMax = x(find(p==max(p)));
%clf, subplot(321)
%plot (x,p)
%xlabel('peak-width FWHM (pxl)'), ylabel('\rho(w) (1/pxl)')
%title(filename,'Interpreter','none')
%set(gcf,'PaperUnits','normalized');
%text(0.1,0.9,sprintf('W_{max}=%4.2f',WidthMax),'Units','normalized')

%dark statistics

%if mode==1
%  x=[max(min(Dark),-5):(min(max(Dark),+5)-max(min(Dark),-5))/sqrt(length(Dark)):...
%        min(max(Dark),+5)];
%  p = hist(Dark,x);
%  subplot(321), stairs(x,p);
%else

[x,p] = pdf_old (Dark,dDark);
%subplot(321), plot (x,p)
z = [];
x1 = x';
  p1 = p';
  z = [x1,p1];

%save('backpdf.dat','z','-ascii');
  
%end
DarkMax = x(find(p==max(p)))
%xlabel('dark-rate (cnt)'), ylabel('\rho(d) (1/cnt)')
%title(filename,'Interpreter','none')
%text(0.1,0.9,sprintf('d_{max}=%4.2f',DarkMax),'Units','normalized')

%intensity statistics
MaxIntensity=cutoffs(2);
IntensityMean = mean(I);
DarkMean = mean (Dark);
%if mode==1
%  x=[max(min(I),0):(min(max(I),MaxIntensity)-max(min(I),0))/sqrt(length(I)):...
%     min(max(I),MaxIntensity)];
%  p = hist(I,x);
%  subplot(3,2,2), stairs(x,p);
%else
  [x,p] = pdf_old (I,dI,0,MaxIntensity);
%  subplot(3,2,2), plot (x,p)
  z = [];
  x1 = x';
  p1 = p';
  z = [x1,p1];
  
	%save('eyfpcaaxdf.dat','z','-ascii');
  
  
%end
IntensityMax = x(find(p==max(p)))

acc_me=mean(W)/((mean(I)/mean(Dark))^0.5)     %positional accuracy from means
dacc_me=dmW/((dmI/dmDark)^0.5) %error
acc_max=WidthMax/((IntensityMax/DarkMax)^0.5)

Dlat_me=((acc_me)^2)/4								%lateral diffusio coeff from means
dDlat_me=((dacc_me)^2)/4								%error
Dlat_max=((acc_max)^2)/4




%size(h(:,5))
%a = x'; b= y';
%save c4lc100check h;
%save c4lc100.data h -ascii;
%DoIt  = ['save ', filename,'.dat h -ascii'];
%eval (DoIt);
%DoIt  = ['save ', filename,'.bin h'];
%eval (DoIt);
