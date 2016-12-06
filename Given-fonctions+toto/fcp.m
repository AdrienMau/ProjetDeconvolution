function [positions, allpositions]=fcp(string, character)
% function positions=fcp(string, character)
% -
% FindCharacterPosition returns the positions of the _character_ in _string_
% except in cases where the _character_ is preceeded by a backslash
% - 
% allpositions contains all instances of _character_ in _string_, while
% position returns only non-quoted (i.e. not preceeded by backslash)
% occurances.

positions=[];
allpositions=[];

if nargin<2
   help fcp
   return
end

allpositions=find(string==character);
   
for j=1:length(allpositions)
	apj=allpositions(j);   
   if apj>0
      if string(apj-1)~='\'
         positions=[positions,apj];
      end %if string
   end % if allpositions
end %for j
