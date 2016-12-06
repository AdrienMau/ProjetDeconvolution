function [PkFound,SeqLen,Xsize,Ysize] = seqfind (file,Option,Image,nX,nY)
%-----------------------------------------------------------------------------
% SEQFIND.M
% calculate the position of dyes for a sequence of CCD-shots
%
% call: [PkFound,YLen,Xsize,Ysize] = seqfind (file, Option)
%
% input: file   -    path of the ASCII-image file
%        Option -(o) see function fitopt()
%
% output: PkFound - # of found peaks
%         YLen    - length of one sequence in y-direction
%	  Xsize,  - size of sub-images
%         Ysize
%
%
% author:  ts
% version: <01.30> from <000330.0000>
%-------------------------------------------------------------
if nargin<1, help seqfind, return, end
if nargin<2, Option=[]; end
%internal parameter
global MASCHINE
result = [];
if nargin==5
  %take image given
  file  = 'test.000';

  Xsize = size(Image,2)/nX;
  Ysize = size(Image,1)/nY;

  SeqLen = nY;
else
  %load image from file given 
  %[Image, ImagePar, Title, Comment] = pmisread (file);
  %[Image, ImagePar, Title, Comment] = speread (file);
  [Image, ImagePar, Title, Comment] = dataread (file);
  nX     = ImagePar(3);
  nY     = ImagePar(4);
  nP     = ImagePar(5);
  Xsize  = ImagePar(1)/nX;
  Ysize  = ImagePar(2)/nY;
  SeqLen = nY;
end

%------------------------------------------------
%loop through the images
for iX=1:nX
   for iP=1:nP
      for iY=1:nY
         NoImage = [iX,iY,iP]
         %SubImage = Image((iY-1)*Ysize+1:iY*Ysize-border,(iX-1)*Xsize+1:iX*Xsize-border);
         SubImage  = getsub (iX,iY,iP,Image,ImagePar);
         r         = findpeak (SubImage, Option);
         if size(r)>0
            nI     = ((iX-1+iP-1)*nY+iY) * ones(size(r,1),1);
            r      = [nI,r];
            result = [result;r];
         end
      end
   end
end

%-------------------------------------------------
%save everything in <file>.pk
if length(result)>0
  PkFound = size(result,1);
  AvgPk   = PkFound / (nX*nY)
  if strcmp(MASCHINE(1:2),'AT')
    DoIt  = ['save pk\',file,' result -ascii']
  elseif strcmp(MASCHINE(1:2),'PC')
    DoIt  = ['save pk\',file,'.pk result -ascii']
  else
    DoIt  = ['save ',file,'.pk result /ascii']
  end
  eval(DoIt)
else
  PkFound = 0;
end
