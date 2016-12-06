function TraceIndex = traceind (file, mode)
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
%--------------------------------------------------------
if nargin<1, help traceind, return, end
if nargin<2, mode=0; end

global MASCHINE 
FileName   = file(1:find(file=='.')-1);
TraceIndex = [];

%load files
if strcmp(MASCHINE(1:2),'AT')
  DoItPk  = ['load pk\',file]
  DoItTrc = ['load trc\',file]
elseif strcmp(MASCHINE(1:2),'PC')
  DoItPk  = ['load ',file,'.spe.pk.dat']
  DoItTrc = ['load trc\',file,'.trc.dat']
else
  DoItPk  = ['load ',file,'.pk']
  DoItTrc = ['load ',file,'.trc']
end
eval(DoItPk)
Peaks=eval(file);
eval(DoItTrc)
Trace=eval(file);

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
  if strcmp(MASCHINE(1:2),'AT')
    DoIt  = ['save ind\',file,' TraceIndex /ascii']
  elseif strcmp(MASCHINE(1:2),'PC')
    DoIt  = ['save ind\',file,'.ind.dat TraceIndex /ascii']
  else
    DoIt = ['save ', file, '.ind TraceIndex /ascii']
  end
  eval(DoIt)
end
