function [data,parameter,title,comment] = Confread (filename)
%function [data,parameter,title,comment] = confread (filename,modereduction,reduction)
%------------------------------------------------------------
% confREAD.M
%
% Call: [data,parameter,title,comment] = confread (filename)
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
% date: 15.06.2001
% author: lc adapted from speread
% version: <01.00> from <990827.0000>
% version: <01.01> from <000822.0000> by GAB
% modif lc : réduction de la taille de l'image
%   BE WARNED -> KINETICS IS A *M*E*S*S* !!!
%----------------------------------------------------------------

global KINETICBORDERS

% Userinput if no filename specified
if nargin==0
  [file,path] = uigetfile('*.img','Load Files from confocal');
  filename = [path,file];
end;

fid = fopen(filename,'r','ieee-le');
fseek(fid,165,-1);
texp = char(fread(fid,7,'char'))';
fclose(fid)

comment=['texp =',texp,' ms'];
title=[filename]
parameter=[100,100,1,1,1];
data=dlmread(filename,'\t',12,0);

