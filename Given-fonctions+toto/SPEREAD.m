function [data,parameter,title,comment] = speread (filename)
%function [data,parameter,title,comment] = speread (filename,modereduction,reduction)
%------------------------------------------------------------
% SPEREAD.M
%
% Call: [data,parameter,title,comment] = speread (filename)
%       si modereduction=1 :
%       reduction ... [xstart ystart taille] de la sous-image
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
%	if a global variable KINETICBORDERS exist, it will be interpreted as
%  [TopBorder BottomBorder] for all images of the kinetic exposure
%  [Another fine hack from GAB & WJ - 20000816.1802]
%
% date: 26.8.1999
% author: ts
% version: <01.00> from <990827.0000>
% version: <01.01> from <000822.0000> by GAB
% modif lc : réduction de la taille de l'image
%   BE WARNED -> KINETICS IS A *M*E*S*S* !!!
%----------------------------------------------------------------

global KINETICBORDERS

% Userinput if no filename specified
if nargin==0
  [file,path] = uigetfile('*.spe','Load WinView - Files');
  filename = [path,file];
end;

%if nargin<2
%   modereduction=0;
%end

%if nargin<3
%   disp('Pas de réduction de la taille de l''image.');
%   modereduction=0;   
%end


% Open file for reading
fi = fopen(filename,'r','ieee-le');
if fi<3
  error('File not found or readerror.');
end;


%some pointers
HeaderSz = 4100;
pXdim    = 42;
pDType	= 108;
ptitle   = 200;
pcomment = ptitle+80;
pYdim    = 656;
pNfram   = 1446;
pNumROI	= 1510;

% adapt for kinetics mode
pReadOutMode = 1480;
pWindowSize = 1482;
pexpos  = 4;
plexpos = 660;
paltexp = 10;
pgain   = 198;
psoft   = 1508;
pwinid  = 2996;

DataType = {'single' 'int32' 'int16' 'uint16'};

% read file - header
fseek(fi,pXdim,-1);
Xdim = fread(fi,1,'uint16');
fseek(fi,pYdim,-1);
Ydim = fread(fi,1,'uint16');
fseek(fi,pNfram,-1);
NFram = fread(fi,1,'int32');
fseek(fi,pNumROI,-1);
NumROI = max([1,fread(fi,1,'int16')]);
fseek(fi,ptitle,-1);
title = char(fread(fi,80,'uchar')');
fseek(fi,pcomment,-1);
comment = char(fread(fi,[4,80],'uchar'));
parameter=[Xdim,Ydim*NFram,1,NFram,NumROI];

fseek(fi,pReadOutMode,-1);
ReadOutMode=fread(fi,1,'uint16');
fseek(fi,pWindowSize,-1);
WindowSize=fread(fi,1,'uint16');
%fseek(fi,pexpos,-1);
%ExPos=fread(fi,1,'int16');
%fseek(fi,plexpos,-1);
%LExPos=fread(fi,1,'int32');
fseek(fi,paltexp,-1);
AltExPos=fread(fi,1,'float32');
%fseek(fi,pgain,-1);
%Gain=fread(fi,1,'uint16')
%fseek(fi,psoft,-1);
%Soft=fread(fi,1,'uint16')
fseek(fi,pwinid,-1);
WinID=fread(fi,1,'int32');

comment=strvcat(comment,['texp = ',num2str(AltExPos*1000),' ms']);

% Reading the datamatrix
fseek(fi,pDType,-1);
nDataType = fread(fi,1,'int16');
sDataType = char(DataType(nDataType+1));
fseek(fi,HeaderSz,-1);
data = fread(fi,[Xdim,Ydim*NFram],sDataType)';

if (ReadOutMode==3)
   if isempty(KINETICBORDERS)
      KINETICBORDERS=[0 0];
   end
   if WindowSize<30	% ugly, ugly, ugly
      					% WindowSize 25 -> crazy thing cant follow trigger
      RealWindowSize=WindowSize*2;
   else
      RealWindowSize=WindowSize;
   end
         
   NImg=(fix(400/RealWindowSize)-1);
   NYdim=Ydim-NImg*(sum(KINETICBORDERS))-RealWindowSize;
   NXdim=NFram*Xdim;
   
   newdata=zeros(NYdim, NXdim);
   idx=[];
   if WindowSize<30	% half a window bottom and top to remove
      					% ARGHHHHH -> find better way to get REAL
      					% values of that (*%^ windowsize!!!!!
	   for i=0.5:(NImg-0.5)
   	   idx=[idx,(KINETICBORDERS(1)+i*RealWindowSize+1):((i+1)*RealWindowSize-KINETICBORDERS(2))];
      end 
   else	% just first window is crap
	   for i=0:(NImg-1)
   	   idx=[idx,(KINETICBORDERS(1)+i*RealWindowSize+1):((i+1)*RealWindowSize-KINETICBORDERS(2))];
      end 
   end
   for i=0:(NFram-1)
      % newdata(:, (i*Xdim+1):((i+1)*Xdim)) =[data((i*Ydim+1):((i+1)*Ydim),:)];
      newdata(:, (i*Xdim+1):((i+1)*Xdim)) = data(idx,:);
      idx=idx+Ydim;
   end
   data=newdata;
   parameter=[NXdim,NYdim,NFram,NImg,NumROI];
end

%if modereduction==1
%smalldata=[];
%for m=1:parameter(3)
%    for k=1:parameter(4)
%        for i=1:reduction(3)
%            for j=1:reduction(3)
%                smalldata(j+reduction(3)*(k-1),i+reduction(3)*(m-1))=data((k-1)*parameter(2)/parameter(4)+reduction(2)+i-1,(m-1)*parameter(1)/parameter(3)+reduction(1)+j-1);
%            end
%        end
%    end    
%end
%smallparameter=[reduction(3)*parameter(3),reduction(3)*parameter(4),parameter(3),parameter(4),parameter(5)];
%data=smalldata;
%parameter=smallparameter;
%else
%end


% close file
fclose(fi);
