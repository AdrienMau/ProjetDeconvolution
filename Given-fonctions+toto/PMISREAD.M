function [data,parameter,title,comment] = pmisread (filename)
%------------------------------------------------------------
% PMISREAD.M
%
% Call: [data,parameter,title,comment] = pmisread (filename)
%
%       data      ... Datamatrix
%       parameter ... [sx,sy,nx,ny,np]
%       title     ... Title from file     
%       comment   ... Comment from file
%       filename  ... Name of file to read (userIO if not set)
%     
%       param:
%              sx ... Imagesize in x- direction
%              sy ... -----"-----  y- direction
%              nx ... Number of subimages in x- direction
%              ny ... Number of subimages in y- direction
%              np ... Number of subimages for different polarizations
%
%
% author: Werner Baumgartner & ts
% version: <02.00> from <980427.0000>
%----------------------------------------------------------------

% Userinput if no filename specified
if nargin==0
  [file,path] = uigetfile('*.*','Load PMI- Files');
  filename = [path,file];
end;

% Open file for reading
fi = fopen(filename,'r','ieee-le');
if fi<3
  error('File not found or readerror.');
end;

% read file - ID
FileID   = fread(fi,4,'char');
HeaderSz = fread(fi,1,'ushort');
PMISVer  = fread(fi,1,'short');
if FileID~=['P';'M';'I';'S']
  error('No PMIS- file');
end;

% read parameterlist
par = fread(fi,6,'short');

% read comment, title and sequence information
nx = 1; ny = 1;
tit     = fread(fi,40,'uchar')';
com     = fread(fi,100,'uchar')';
title   = setstr(tit(1:find(tit==0)-1));
comment = setstr(com(1:find(com==0)-1));

% get seqence information (old: 'seq:ny x nx')
SPos = findstr(comment, 'seq:');
if ~isempty(SPos)
  NSeq = sscanf(comment(SPos(1):length(com)),'seq:%dx%d');
  if length(NSeq)>0
    ny = NSeq(1);
    if length(NSeq)>1
      nx = NSeq(2);
    end
  end
else
  % get seqence information (new: '(M:nx x ny x np)'  or  '(S:nx x ny x np)')
  SPos = findstr(comment,'(S:');
  if isempty(SPos);
     SPos = findstr(comment,'(M:');
  end
  if ~isempty(SPos)
     NSeq = sscanf(comment(SPos(1)+3:length(comment)),'%d x%d x%d)');
     if length(NSeq)>0
        if length(NSeq)>2
           nx = NSeq(1)*NSeq(3);
           np = NSeq(3);
        else
           nx = NSeq(1);
           np = 1;
      end
      ny = NSeq(2);
    end
  end
end



% set parameter to size of image and number of subimages
parameter = [par(3),par(4),nx,ny,np];

% move filepointer to data
fseek(fi,HeaderSz,-1);

% Reading the datamatrix
data = fread(fi,[par(3),par(4)],'short')';


fclose(fi);
