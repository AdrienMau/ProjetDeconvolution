function OutVec=ct2PCS(filename, timing, cutoffs, mode, savefile, sizepixel)
% function OutVec = ct2PCS(filename, timing, cutoffs, mode, savefile, sizepixel)
% --
% filename ... string describing the SPE data files to be analyzed
%              can contain expandable expressions [see sbe()]
% timing   ... vector of two elements [till tlag]
%    till         illumination time in ms {1}
%    tlag         timelag between two exposures in ms {100}
% cutoffs  ... vector of three elements [RelErr MaxCount MaxTrace]
%    RelErr       maximum allowed relative error in peak intensity {1/3}
%    MaxCount     maximum allowed peak intensity {1000}
%    MaxTrace     maximum allowed trace length {20}
% mode     ... defines output, see history below for details {0}
% savefiles... if a savefile is given, filtered data will be saved
% sizepixel in nm
% OutVec are not yet implemented
% -- 
% Version 1.0 11/7/2000 by GAB & PL
% Version 1.1 18/7/2000 by GAB - included multiple files
% Version 1.2 19/7/2000 by GAB & PL - fixed some bugs regarding msd
% Version 1.3 24/7/2000 by GAB - allowing wildcards (sbe) 
% Version 1.4 27/7/2000 by WJ & PL & GAB - made the meaning of the 'mode' parameter more consistent:
%                    mode 0  - standard analyze output
%						   mode 1  - histogram instead of probability density for the 
%										 peak intensity & diffusion constant.
%					NEW!	mode 2  - Distribution function P(r^2;t) instead of diffusion constant diagram
%							timing now includes timelag
%							started to adapt MSD to um^2 instead of pxl
%              02/8/2000 PL & GAB - 
% Version 1.5 22/8/2000 by GAB - redid help to be readable by americans
% --

% TODO
%   * add directory to filenames (check with appending pk/ ind/ trc/ !)

global MASCHINE
global BORDER

% check for input parameters

if nargin < 1 % no parameter at all
   help checkthattoo
   return
end

if nargin < 6
   InVec=[];
end
if nargin <5
   savefile=[];
end
if nargin < 4
   mode=0;
end
if nargin < 3
   cutoffs = [1/3 0 1000 20];
	disp('Set default cutoff values 1/3 relErr, 1000 cntsMax and maximum trace=20');
end
if nargin < 2
 	timing=[1 100];
	disp('Set default illumination 1ms, timelag 100ms');
end

till=timing(1);
timelag=timing(2);
disp('attention !!! ligne 67 ''analysetout (filename,cutoffs(3)) mis en commentaire'' ');
%analysetout (filename,cutoffs(3));

%trace filename

files=sbe(filename,1);
pkdata=[]; trcdata=[]; inddata=[];
maxim=0; maxtrc=0;

for k=1:length(files)
   
   str=['pk\',files(k).name,'.pk'];
   if length(dir(str))>0		% is there new peakdata?
      Spkdata =load(str);
      SPok=1;
   else
%      disp(['Couldn''t find peak file ',str]);
      Spkdata= [];
      SPok=0;
   end
   
   str=['trc\',files(k).name,'.trc'];
   if length(dir(str))>0     % is there new trcdata?
      Strcdata=load(str);
      STok=1;
   else
 %     disp(['Couldn''t find trace file ',str]);
      Strcdata=[];
      STok=0;
   end
   
   str=['ind\',files(k).name,'.ind'];
   if length(dir(str))>0		% is there new indexdata? 
      Sinddata=load(str);
      SIok=1;
	else
 %     disp(['Couldn''t find index file ',str]);
      Sinddata=[];
      SIok=0;
   end
   % msddata=load(['msd\',filename,'.msd']);
   
   disp([' * found ',num2str(size(Spkdata,1)),' peaks and ',num2str(size(Sinddata,1)),' traces in file ',files(k).name]);
   if SPok>0
      Spkdata(:,1)=Spkdata(:,1)+maxim;		% new imagenumber
   end
   
   if STok>0
      Strcdata(:,2)=Strcdata(:,2)+maxim;	% -"-
      Strcdata(:,1)=Strcdata(:,1)+maxtrc; % new tracenumber
   end
   
   if SIok>0
      Sinddata(:,1)=Sinddata(:,1)+maxtrc; % -"-
      validind=logical([zeros(size(Sinddata,1),1),Sinddata(:,2:end)>0]);
      Sinddata(validind)=Sinddata(validind)+size(pkdata,1);
      												% new index in pkdata
   end
     
   if ~isempty(inddata)		% indexdata can have different length (max. length of trace)
      maxind=size(inddata,2);
      newind=size(Sinddata,2);
      if maxind>newind
         Sinddata=[Sinddata, zeros(size(Sinddata,1),maxind-newind)];
      elseif maxind<newind
         inddata=[inddata, zeros(size(inddata,1),newind-maxind)];
      end
   end
   
   pkdata=[pkdata; Spkdata];
   trcdata=[trcdata;Strcdata];
   inddata=[inddata;Sinddata];
   
   if ~isempty(pkdata)
      maxim=max(pkdata(:,1));
   end
   if ~isempty(trcdata)
      maxtrc=max(trcdata(:,1));
   end
end


if length(pkdata)==0
   error('No data.');
end

disp(['Starting with ',num2str(size(pkdata,1)),' peaks and ',num2str(size(inddata,1)),' traces.']);

pkind = find(pkdata(:,10)<(pkdata(:,5)*cutoffs(1)) & pkdata(:,5)>cutoffs(2) & pkdata(:,5)< cutoffs(3)) ;
trclen= sum(inddata(:,2:end)>0,2);

ninddata=inddata(trclen<cutoffs(4),:);
indpk=inddata(trclen>=cutoffs(4),2:end);

pkind=setdiff(pkind,indpk(:)); % remove all peaks in traces longer than max. trace;
										 % pkind now contains all approved datapoints
npkdata = pkdata(pkind,:);
% npkdata(:,[5 6 10 11])=npkdata(:,[5 6 10 11])/till; %removed by Wimjan Aug 2, 2000

if size(npkdata,1)<1
   disp('Data was crap, no points left.');
   return;
end

ntrclen=sum(ninddata(:,2:end)>0,2);
maxtrace=max(ntrclen);
ntrcdata=[];

for i=1:size(ninddata,1)	% work through all remaining traces from ninddata
	rp=[];
   for j=2:ntrclen(i)+1	% 1st ist trcnumber, 2:end are positions in pkdata
      pk=find(pkind==ninddata(i,j));
      if isempty(pk) % corresponding peak has been deleted
         rp=[rp, j];
      else
         ninddata(i,j)=pk; % set new position in npkdata
       %  pk
         td=trcdata(find(trcdata(:,1)==ninddata(i,1) & trcdata(:,2)==npkdata(pk,1)),:);
         	% get line from trcdata
         td(1)=i;	% number of trace has changed
         ntrcdata=[ntrcdata;td];
      end
   end
   ninddata(i,1)=i;	% set new trace number
   if length(rp)>0
      for j=0:length(rp)-1
		   ninddata(i,rp(j+1)-j:end)=[ninddata(i,rp(j+1)+1-j:end),0];	% remove the point from the index
      end
   end
end

ntrclen=sum(ninddata(:,2:end)>0,2);
emptytrace=find(ntrclen<2);

if ~isempty(ntrcdata)
	if ~isempty(emptytrace)	% there are traces to remove
	   ti = ones(size(ntrcdata,1),1); % trace index
   	ii = ones(size(ninddata,1),1); % index index
	   for i=1:length(emptytrace)
   	   ti = ti & (ntrcdata(:,1)~=emptytrace(i));
      	ii(emptytrace(i))=0;
	   end
   	ntrcdata=ntrcdata(ti,:);
	   ninddata=ninddata(logical(ii),:);
   end
else
   ntrcdata=[];
   ninddata=[];
end


disp([num2str(size(npkdata,1)),' peaks and ',num2str(size(ninddata,1)),' traces left after cutoff.']);

if length(ntrcdata)==0
   disp('No more traces left.');
end


if size(ninddata,1)>0
    cutoffs(4)
   [nmsddata, fmsddata] = ct2_msdshort(ntrcdata,cutoffs(4));	% calculate mean square displacement
   MeanD = mean(nmsddata(:,3)./nmsddata(:,2))/4;
else
   nmsddata=[0 0 0 0];
   MeanD = 0;
end

otrclen=size(trcdata,1); opklen=size(pkdata,1);
clear trcdata inddata pkdata % we won't need those anymore.

%% 

savefile
if ~isempty(savefile)
   r='y';
   if ~isempty(dir([savefile,'.pk']))
      r=input('/n*The specified savefile already exists. Overwrite [Y/n]','s');
      if isempty(r)
         r='y';
      end
   end
   r=upper(r);
   if r=='Y' | r=='J'
      disp(['Writing data to file ',savefile,'.[pk, ind, trc, msd]']);
      save([savefile,'.pk'],'npkdata','-ascii');
      save([savefile,'.ind'],'ninddata','-ascii');
      save([savefile,'.trc'],'ntrcdata','-ascii');
      save([savefile,'.msd'],'nmsddata','-ascii');
      disp('coucou');
   end
end

%% make analyze at home

NSeq = max(npkdata(:,1));


PeaksFound = length(npkdata(:,1));
ind = find (rem(npkdata(:,1),NSeq)==1);
FirstPeaksFound = length(ind);

%get the width, and intensity information
W     = npkdata(:,4);
dW    = npkdata(:,9);
Dark  = npkdata(:,6);
dDark = npkdata(:,11);
%I     = pi / 4 / log(2) * npkdata(:,5) .* W.^2;
%dI    = sqrt((npkdata(:,10)./npkdata(:,5)).^2 + (2*dW./W).^2) .* I;
I     = npkdata(:,5);
dI    = npkdata(:,10);

%width statistics
[x,p] = pdf_old (W,dW,0,5);
WidthMax = x(find(p==max(p)));
clf, subplot(321)
plot (x,p)
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
subplot(321), plot (x,p)
z = [];
x1 = x';
  p1 = p';
  z = [x1,p1];
%if you want to save the background pdf, engage this command:
%save('backpdf.dat','z','-ascii');
  
%end
DarkMax = x(find(p==max(p)));
xlabel('dark-rate (cnt)'), ylabel('\rho(d) (1/cnt)')
title(filename,'Interpreter','none')
text(0.1,0.9,sprintf('d_{max}=%4.2f',DarkMax),'Units','normalized')

%intensity statistics
MaxIntensity=cutoffs(3);
IntensityMean = mean (I);
DarkMean = mean (npkdata(:,6));
if mode==1
  x=[max(min(I),0):(min(max(I),MaxIntensity)-max(min(I),0))/sqrt(length(I)):...
     min(max(I),MaxIntensity)];
  p = hist(I,x);
  save([filename,'.INThisto.dat'],'I','-ascii');
  subplot(3,2,2), stairs(x,p);
else
  [x,p] = pdf_old (I,dI,0,MaxIntensity);
  subplot(3,2,2), plot (x,p)
  z = [];
  x1 = x';
  p1 = p';
  z = [x1,p1];
  % if you want to save the pdf...engage this command line
	save([filename,'.INTpdf.dat'],'z','-ascii');
%    doit = ['save ', filename,'.dat.', 'z -ascii'];
  
  
end
IntensityMax = x(find(p==max(p)));
xlabel('peak-intensity (cnt)'), ylabel('\rho(I_{p}) (1/cnt)')

text(0.5,0.9,['I_{max} = ',num2str(IntensityMax)],'Units','normalized');
text(0.5,0.8,['<I>  = ',num2str(IntensityMean)],'Units','normalized');
text(0.5,0.7,['I_{dark}= ',num2str(DarkMean)],'Units','normalized');
text(0.5,0.6,['N= ',num2str(size(npkdata,1)),' (',num2str(100*size(npkdata,1)/opklen),'%)'],'Units','normalized');
text(0.5,0.5,['t_{ill}= ',num2str(till),' ms'],'Units','normalized');


if ~isempty(ntrcdata)
   NoTrace = max(ntrcdata(:,1));
else
   NoTrace=[];
end

TrcLen  = ones(1,PeaksFound-size(ntrcdata,1));

subplot(3,2,3)

if size(npkdata,1)>0
	plot(npkdata(:,2),-npkdata(:,3),'g.','MarkerSize',6);
end

hold on

if ~isempty(NoTrace)
   %axis ([min(ntrcdata(:,3)),max(ntrcdata(:,3)),-max(ntrcdata(:,4)),-min(ntrcdata(:,4))])
   axis ([0,100,-100,0])
   for itrc=1:NoTrace
	   ind = find (ntrcdata(:,1)==itrc);
	   if length(ind)>0
	%      tl  = length(ntrcdata(ind,1));
	%      if (size(ntrcdata,2)<5)
	%        TrcLen = [TrcLen,ntrcdata(ind(tl),2)-ntrcdata(ind(1),2)+1];
	%	   else
	%   	   if (ntrcdata(ind(tl),5)==-1) | (ntrcdata(ind(tl),2)-ntrcdata(ind(1),2)+1==NSeq)
	%      		TrcLen = [TrcLen,ntrcdata(ind(tl),2)-ntrcdata(ind(1),2)+1];%
	%	      end
	%   	end
	   	plot (ntrcdata(ind,3), -ntrcdata(ind,4),'b-',ntrcdata(ind,3), -ntrcdata(ind,4),'ro')
		end
   end
end

hold off
axis ('normal')
xlabel ('X-position (pxl)'), ylabel('-Y-position (pxl)')

%plot histogram of trace-lengths and calulation of bleaching time
subplot(3,2,4)

if ~isempty(NoTrace)
	TrcLen=sum(ninddata(:,2:end)>0,2);
	MaxTrc = max(TrcLen);
	HistTrcLen = hist (TrcLen,MaxTrc-1);
	ind = find (HistTrcLen>0);
    save([filename,'.BLEACH.dat'],'TrcLen','-ascii');
	if length(ind)>1
	   ind = ind(2:length(ind));
	   tBleach = (2:MaxTrc);
	   tBleach = tBleach(ind) ./ log(HistTrcLen(1)./HistTrcLen(ind));
	   std_tBleach=std(tBleach);
	   tBleach = mean(tBleach);
	else
		tBleach = 0; std_tBleach=0;
	end

	stairs (1:MaxTrc+2,[0 HistTrcLen 0 0]);
	xlabel ('length of trace (pxl)'), ylabel ('occurrence');
   text(0.5,0.9,sprintf(' N_{datapoints}=%4d',size(ntrcdata,1)),'Units','normalized');
	%txt = axis; text(0.65*txt(2),0.8*txt(4),sprintf('N1=%3d',FirstPeaksFound))
	%changed by GAB & PL
	text(0.65,0.8,['N_{traces}=',num2str(size(ninddata,1))],'Units','normalized');
	text(0.65,0.2,sprintf('t_{B}=%4.2f',tBleach),'Units','normalized');
	text(0.65,0.1,sprintf('+- %4.2f',std_tBleach),'Units','normalized');
  

	%statistics of the diffusion constant
	%ind   = find (nmsddata(:,3)~=nmsddata(:,4));
	ind = 1:size(nmsddata,1);
	Diff  = nmsddata(ind,3) ./ nmsddata(ind,2) / 4;
	dDiff = nmsddata(ind,4) ./ nmsddata(ind,2) / 4;
	MaxTrc = max(nmsddata(:,2)) ;
	MeanD  = mean(Diff);
   if mode==1
	  xlabel('diffusion constant (pxl/lag)'), ylabel('\rho(D) (lag/pxl)')
     text(0.5,0.8,sprintf(' <D>=%4.2f +/- %4.2f',MeanD,std(Diff)),'Units','normalized')
     x = [max(min(Diff),0):(max(Diff)-max(min(Diff),0))/sqrt(length(Diff)):...
     max(Diff)];
     p = hist(Diff,x);
     subplot(3,2,5), stairs(x,p);
   else 
      if mode == 2
        fullpdf=[];
         subplot(3,2,5);
         hold on;
         fmsddata=fmsddata*(sizepixel/1000)^2; % go from pxl => um^2
         save ('fmsddata', 'fmsddata', '-ascii');
	      for step=1:size(fmsddata,2)
  				OnzeVector = sort(fmsddata(find(fmsddata(:,step)~=0), step))';    
   	      if ~isempty(OnzeVector)
               AantalVector = linspace(0,1,length(OnzeVector));
               % timing now in [ms]
                 OnzeData = [OnzeVector', AantalVector'];
%           	 filename = '';
			     filename = sprintf('dist%02.0f.dat', step);
                 doit = ['save ', filename, ' OnzeData -ascii'];
                 eval(doit);
               fullpdf=[fullpdf;OnzeData];
               filename = sprintf('fullDist.dat', step);
               doit = ['save ', filename, ' fullpdf -ascii'];
               eval(doit);
               
              if step==1
   					plot(OnzeVector, AantalVector);
                  xlabel('r^2 [{\mu}m^2]'), ylabel('P(r^2, t [ms])')
	   	         text(0.5,0.5,sprintf(' N_{1 step} = %4.0f',length(OnzeVector)),'Units','normalized')
   	   	      text(0.5,0.35,sprintf(' t_{lag} = %4.0f ms',step*timelag),'Units','normalized')
      	      end % if step==1
%         axis([0 5 0.5 1]);
	   			end % if ~isempty(OnzeVector)
         end % for step
         hold off
      else
   		[x,p] = pdf_old (Diff,dDiff,0,4*MeanD);
	   	subplot(3,2,5), plot (x,p)
			xlabel('diffusion constant (pxl/lag)'), ylabel('\rho(D) (lag/pxl)')
	     	text(0.5,0.8,sprintf(' <D>=%4.2f +/- %4.2f',MeanD,std(Diff)),'Units','normalized')
      end % if mode
	end % if length(ind)
%	xlabel('diffusion constant (pxl/lag)'), ylabel('\rho(D) (lag/pxl)')
%	text(0.5,0.8,sprintf(' <D>=%4.2f \pm %4.2f',MeanD,std(Diff)),'Units','normalized')

	%linear MSD-plot
	subplot(3,2,6)
%	axis ([0,max(nmsddata(:,2)),0,max(nmsddata(:,3))])
%	for itrc=1:max(nmsddata(:,1))
%		ind = find (nmsddata(:,1)==itrc);
%		if length(ind)>0
%			plot ([0;nmsddata(ind,2)], [0;nmsddata(ind,3)])
%			hold on
%		end
%	end

	ntrc=size(fmsddata,2);
	tdat=[];
   for noz=1:ntrc
      val=fmsddata(:,noz); val=val(val>0);
      if length(val)>0
         tdat=[tdat;[mean(val), std(val)/sqrt(length(val))]];
      else
         tdat=[tdat;[0 0]];
      end
   end
   
   
   plot(1:ntrc,tdat(:,1),'b*',1:ntrc,tdat(:,1)+tdat(:,2),'b^',1:ntrc,tdat(:,1)-tdat(:,2),'bv');
   
   if isempty(savefile)
      save('MSD.ntrc','tdat','-ascii');
   else
      save([savefile,'.ntrc'],'tdat','-ascii');
   end
   
	hold off
	axis ('normal')
	xlabel ('time lag'), ylabel('MSD (pixel^2)')
%	txt = axis; text(0.65*txt(2),0.2*txt(4),sprintf('#trc=%3d',size(ninddata,1)))

else
  	text(0.25,0.9,'No Traces.','Units','normalized');
end % if ~isempty(Notrace)

pause(1)
%---------------------------------------------------------
%report result
%set(gcf,'PaperType','A4','PaperOrientation','Portrait','PaperUnits','normalized','PaperPosition',[0.05 0.05 0.95 0.95]);

%if nargin>4
 % OutVec=[PeaksFound,FirstPeaksFound,WidthMax,DarkMax,IntensityMax, ...
      %    IntensityMean,NoTrace,MaxTrc,MeanD,tBleach];
  %OutVec=[InVec;OutVec];
  %end
%if ((strcmp(MASCHINE(1:2),'AT')|strcmp(MASCHINE(1:2),'PC')) & mode>=10)
  %set (gcf,'PaperType','A4')
  %print
  %pause (20)
  %end

IntensityMean