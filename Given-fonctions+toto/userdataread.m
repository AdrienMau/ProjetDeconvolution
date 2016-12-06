function [data,parameter,title,comment] = userdataread (filename)
%------------------------------------------------------------
% userDATAREAD.M
%	read data files of type: PMIS, WinView, PMS, ConfoCor, Confocal
%
% Call: [data,parameter,title,comment] = userdataread (filename)
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
% date: 6-4-2000
% author: ts, lc modif for confocal
% version: <01.00> from <000406.0000>
%----------------------------------------------------------------
% Userinput if no filename specified
if nargin==0
	[file,path] = uigetfile('*.*','Load Data-File');
	filename = [path,file];
end


if strcmp(filename,'help'), help dataread, return, end

% Open file for reading
fid = fopen(filename,'r','ieee-le');
if fid<3
	error('File not found or readerror.');
	return  
end

%-----------------------------------------------------------------
% now test for file-type by reading file-ID
pID_PMIS	= 0;
pID_WinView = 2996;
pID_PMS = 0;
pID_ConfoCor = 0;
pID_Confocal = 0;

% PMIS
fseek(fid,pID_PMIS,-1);
FileID = char(fread(fid,4,'char'))';
if strcmp(FileID,'PMIS')
	fclose(fid);
	[data,parameter,title,comment] = pmisread (filename);
   if length(parameter)<5
      parameter = [parameter,1];
   end
	return
end

% WinView
fseek(fid,pID_WinView,-1);
WinID = fread(fid,1,'int32')';
if (WinID == 19088743) % 0x1234567 
   fclose(fid);
    [data,parameter,title,comment] = speread (filename);
    return
end

% PMS
fseek(fid,pID_PMS,-1);
FileID = char(fread(fid,5,'char'))';
if strcmp(FileID,'PMS -')
	fclose(fid);
	[data,parameter,title,comment] = sclmread (filename);
	return
end

% ConfoCor
fseek(fid,pID_ConfoCor,-1);
FileID = char(fread(fid,4,'char'))';
if strcmp(FileID,'PMIS')
	fclose(fid);
   [data,parameter,title,comment] = FCSread (filename);
	return
end

% ConfoCal
fseek(fid,pID_Confocal,-1);
FileID = char(fread(fid,6,'char'))';
if strcmp(FileID,'Single')
	fclose(fid);
   [data,parameter,title,comment] = Confread (filename);
	return
end

% no match found
fclose(fid)
error('File-Type unknown.')
