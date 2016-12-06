function File = fileinc (File)
%-----------------------------------------
%
% FILEINC.M
% Increment file type by 1
%
% date: 27.11.1997
% author: ts
% version: <00.00> from <971127.0000>
%-----------------------------------------
if nargin<1, help fileinc, return, end

pDot = findstr (File,'.');
form = '%03.3d';
if File(pDot+1)<'0' | File(pDot+1)>'9'
  pDot = pDot+1;
  form = '%02.2d';
end
if File(pDot+1)<'0' | File(pDot+1)>'9'
  pDot = pDot+1;
  form = '%d';
end

cnt  = str2num (File(pDot+1:length(File)));
File = [File(1:pDot),sprintf(form,cnt+1)];

