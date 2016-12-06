function TraceIndex = traceind (file, mode, dummy)
%---------------------------------------------------------------
% TRACEIND.M
% generates an indexfile which correlates the file <file>.pk
% with the file <file>.trc
%
% call: TraceIndex = seqtrace (file, mode)
%
% input: file  -     path of the peak-file
%        mode  -  0: output as vector (def.)
%                 1: output a vector and store to <file>.ind
%
% output:   the output ist stored in the file <file>.ind
%           TraceIndex - the index-vector
%                        [iTrace,iPeak,jPeak,...,nPeak]
%
% date:    10.11.1995
% author:  ts
% version: <01.01> from <000330.0000>
% 			  <01.02> from <000818.0000> by GAB
%--------------------------------------------------------
if nargin<1, help traceind, return, end
if nargin<2, mode=0; end
if nargin<3, dummy=0; end
TraceIndex = [];

if ischar(file) % filename has been given
% 	global MASCHINE 
% 	FileName   = file(1:find(file=='.')-1);
% 	TraceIndex = [];
% 
% 	%load files
% 	if strcmp(MASCHINE(1:2),'AT')
% 	  DoItPk  = ['load pk\',file];
% 	  DoItTrc = ['load trc\',file];
% 	elseif strcmp(MASCHINE(1:2),'PC')
% 	  DoItPk  = ['load pk\',file,'.pk'];
% 	  DoItTrc = ['load trc\',file,'.trc'];
% 	else
% 	  DoItPk  = ['load ',file,'.pk'];
% 	  DoItTrc = ['load ',file,'.trc'];
% 	end
% 
% 	FileName(FileName=='-')='_';	% no '-' in variable names allowed => use '_' instead
% 	eval(DoItPk);
% 	Peaks=eval(FileName);
% 	eval(DoItTrc);
%    Trace=eval(FileName);
    cd pk
    Peaks=load([file,'.pk']);
    cd ..
    cd trc
    Trace=load([file,'.trc']);
    cd ..
   
else % assume datamatrices to be given by arguments 1 & 2
   if size(file,2)~=15 | size(mode,2)~=5
      error('Input data matrices have wrong format.');
   end
   Peaks=file;
   Trace=mode;
   mode=dummy;
end




%------------------------------------------------
%loop through the traces
for itr=1:max(Trace(:,1))
  NTrc = Trace(find(Trace(:,1)==itr),:);
  indtrc = [];
  for ii=1:size(NTrc,1)
    indpk = find(Peaks(:,1)==NTrc(ii,2) &...
                 Peaks(:,2)==NTrc(ii,3) &...
                 Peaks(:,3)==NTrc(ii,4) );
              indtrc = [indtrc,indpk'];
              
  end    
indtrc = [itr,indtrc];
fill   = length(indtrc) - size(TraceIndex,2);
TraceIndex = [TraceIndex,zeros(size(TraceIndex,1),max(0,fill));...
              indtrc,zeros(1,max(0,-fill))];
end

%-------------------------------------------------
%save everything to <file>.ind
if mode==1 
  
   
 
    DoIt  = ['save ind\',file,'.ind TraceIndex /ascii'];
 
    %DoIt = ['save ', file, '.ind TraceIndex /ascii'];
  
  eval(DoIt);
end
