function [NImage,Occurrence] = occursta (file, NSeq, Conf)
%--------------------------------------------------------
% OCCURSTA.M
%
% analysis of fitted data
%
% function	[NImage,Occurrence] = occursta (file, NSeq, Conf)
%
% input:	file - filename
%		Conf - confidence interval for data
%		       ie points for conf*x<dx are rejected
%               NSeq - length of a sequence
%    
% output:	NImage     - # image of first occurrance
%               Occurrence - # of occurrences
%               the output can directly used in functions: BAR, STAIRS	
%
%--------------------------------------------------------
if nargin<1, help occursta, return, end
if nargin<3, Conf=[]; end

global MASCHINE
%---------------------------------------
%<file>.pk - the output of SEQFIND
if strcmp(MASCHINE,'convex')
  DoIt  = ['load ',file,'.pk']
else
  DoIt  = ['load pk\',file]
end
FName = file(1:find(file=='.')-1);
eval (DoIt)
P = eval(FName);

%cancel points out of the confidence interval
P = clearpk (P,Conf,1);
if length(P)<=0
  return
end
PeaksFound = length(P(:,1))

%-------------------------------------------------------------------
%<file>.trc  -  output of SEQTRACE
if strcmp(MASCHINE,'convex')
  DoIt  = ['load ',file,'.trc'];
else
  DoIt  = ['load trc\',file];
end
FName = file(1:find(file=='.')-1);
eval (DoIt)
T = eval(FName);
NoTrace = max(T(:,1))

%-------------------------------------------------------------------
%cancle out data points in P which also occure in T
DelInd = [];

for itrc=1:NoTrace
  TrcInd = find (T(:,1)==itrc);
  for iim=2:length(TrcInd)
    DelInd = [DelInd, find((P(:,1)==T(TrcInd(iim),2)) & ...
                           (P(:,2)==T(TrcInd(iim),3)) & ...
                           (P(:,3)==T(TrcInd(iim),4))       ) ];
  end
end

P(DelInd,1) = 0 * P(DelInd,1);
PInd = find (P(:,1)~=0);
P = P(PInd,:);
 
%--------------------------------------------------------------------
% calculate starting points and its statistics
if nargin<2
  NSeq = size (P,1);
end
Start = [rem(P(:,1)-1,NSeq)+0.0001;NSeq];
[NImage,Occurrence] = hist(Start,NSeq);
Occurrence(NSeq) = Occurrence(NSeq)-1;
