 function  MeanD = seqmsd (file)
%--------------------------------------------------------
% SEQMSD.M
% Calculation of the mean-sqare displacement from the traces
% in the input-file. The result is stored in <file>.msd
%
% call: MeanD =  seqmsd (file)
%
% input: file   - path of the image-file. The trace is found in
%                 <file>.trc
%
% output:   the output ist stored in the file
%           <file>.msd - mean-square displacement for each trace
%           MeanD - average diffusion constant for timelag 1 of all traces
%
% see also: msd
%
%
% date:    30.7.1994
% author:  ts
% version: <01.02> from <000330.0000>
%--------------------------------------------------------
if nargin<1, help seqmsd, return, end
global MASCHINE

if strcmp(MASCHINE(1:2),'AT')
  DoIt  = ['load trc\',file];
elseif strcmp(MASCHINE(1:2),'PC')
  DoIt  = ['load trc\',file,'.trc'];
else
  DoIt  = ['load ',file,'.trc'];
end
eval(DoIt);
TrcName = file(1:find(file=='.')-1);
TrcName(TrcName=='-')='_';	% no '-' in variable names allowed => use '_' instead
Trc=eval(TrcName);

MSqDispl = msd(Trc);
MeanD = mean(MSqDispl(:,3)./MSqDispl(:,2))/4

if strcmp(MASCHINE(1:2),'AT')
  DoIt  = ['save msd\',file,' MSqDispl -ascii']
elseif strcmp(MASCHINE(1:2),'PC')
  DoIt  = ['save msd\',file,'.msd MSqDispl -ascii']
else
  DoIt = ['save ', file, '.msd MSqDispl /ascii']
end
eval(DoIt)
