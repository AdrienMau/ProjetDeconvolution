function [TraceFound,AllTrace] = seqtrace (file, nSeq, D, Xmax, Ymax, Opts,savename)
%---------------------------------------------------------------
% SEQTRACE.M
% Calculate the trace of dyes found by the program seqfind()
% and stored in the file <file>.pk
% save the new trace in trc/savename.trc
% call: TraceFound = seqtrace (file, nSeq, D, Xmax, Ymax, Opts)
%
% input: file  -     path of the peak-file OR directly peak data matrix
%        nSeq  -     number of successive images
%        D     - (o) estimated diffusion coefficient
%	 		Xmax  - (o) size of individual images
%        Ymax    (o)
%        Opts  - (o) fit parameter (see fitopt())
%
% output:   the output ist stored in the file <file>.trc
%           TraceFound - # of traces found
%
%
%
% see also: seqfind, findpeak, clearpk, track
%
%
% date:    25.7.1994
% author:  ts
% version: <02.02> from <000330.0000>
% 			  <02.03> from <000818.0000> by GAB
%								allow input from file or directly from datamatrix
%--------------------------------------------------------
if nargin<1, help seqtrace, return, end

if nargin<7,
    SaveData=0;
else SaveData=1;
end    
AllTrace = [];


if ischar(file) %load image from file given
	global MASCHINE 
	if strcmp(MASCHINE(1:2),'AT')
	  DoIt  = ['load pk\',file];
	elseif strcmp(MASCHINE(1:2),'PC')
	  DoIt  = ['load pk\',file,'.pk'];
	else
	  DoIt  = ['load ',file,'.pk'];
	end
	eval(DoIt);
	PeakName = file(1:find(file=='.')-1);
	PeakName(PeakName=='-')='_';	% no '-' in variable names allowed => use '_' instead
   Peaks=eval(PeakName);
   
else %otherwise try to take the datamatrix directly
   if size(file,2)~=15
      error('Input data matrix has wrong format!');
   end
   Peaks=file;
end

%determine # of images scanned
Iend   = max(Peaks(:,1));
if nargin<2, nSeq=Iend; end
if nargin<3, D=1; end
if nargin<4, Xmax=max(Peaks(:,2)+D); end
if nargin<5, Ymax=max(Peaks(:,3)+D); end
if nargin<6, Opts=[]; end

%------------------------------------------------
%loop through the images
Iseq = fix(min(Peaks(:,1))/nSeq)*nSeq+1;
Itrc = 0;
while Iseq<Iend 
  SeqPk = Peaks(find((Peaks(:,1)>=Iseq)&(Peaks(:,1)<Iseq+nSeq)),:);
  disp(['Xmax = ' Num2str(Xmax) ' et Ymax = ' Num2str(Ymax)]);
  SeqTrc = mktrace (SeqPk, D, Xmax, Ymax, Opts);
  

  if length(SeqTrc)>0
    SeqTrc(:,1) = SeqTrc(:,1)+Itrc;
    AllTrace = [AllTrace; SeqTrc];
    IAllTrace=AllTrace(:,1);
    Itrc = max(AllTrace(:,1));
  end
  Iseq = Iseq+nSeq;
end

%-------------------------------------------------
%save everything in file <file>.trc

if (length(AllTrace)>0)
	TraceFound = max(AllTrace(:,1));
    if SaveData==1
        save(['trc\',savename,'.trc'],'AllTrace','-ascii');
        traceind (savename, 1);
        %	if strcmp(MASCHINE(1:2),'AT')
		%	DoIt  = ['save trc\',file,' AllTrace -ascii']
        %elseif strcmp(MASCHINE(1:2),'PC')
	   	%DoIt  = ['save trc\',file,'.trc AllTrace -ascii']
        %else
	   	%DoIt = ['save ', file, '.trc AllTrace /ascii']
        %end
      %eval(DoIt)
  end
else
  TraceFound = 0;
end
disp(['On trouve par seqtrace ' Num2str(TraceFound) ' traces.']);

