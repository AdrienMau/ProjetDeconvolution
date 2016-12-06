function pmissave (file, data, title, comment, subx, suby)            
%-----------------------------------------------------
% PMISSAVE.M
%
% Call: pmissave (file,data,title,comment,subx,suby)
%
%       file    ... name of file to write
%       data    ... datamatrix
%       title   ... (o) title from file
%       comment ... (o) comment from file
%       subx    ... (o) # sub-images in X-dir
%       suby    ... (o) # sub-images in Y-dir
%
% date: 19.5.1995
% author: ts
% version: <01.02> from <950928.0000>
%____________________________________________________________
if nargin<2, help pmissave, return, end
if nargin<3, title=[' ']; end
if nargin<4, comment=[]; end
if nargin<5, subx=1; end
if nargin<6, suby=1; end

data = data';
[nx,ny] = size(data);
comment = ['(S:',int2str(suby),'x',int2str(subx),'),',comment];
title   = title(1:min(40,length(title)));
comment = comment(1:min(100,length(comment)));

% open file to write
stream = fopen(file,'w','ieee-le');
if stream<3
  error('file open error.');
end;

% write file-ID
fwrite (stream,'PMIS','char');

%1.part of header
fwrite (stream,[172,20,0,0],'short');

% write image-size
fwrite (stream,[nx;ny],'short');

%2.part of header
fwrite (stream,[1,1],'short');

% write title
fwrite (stream,title,'char');
fwrite (stream,' '*zeros(1,40-length(title)),'char');

% write comment
fwrite (stream,comment,'char');
fwrite (stream,' '*zeros(1,100-length(comment)),'char');

%3.dummy
fwrite (stream,zeros(1,6),'short');

% write the datamatrix
fwrite (stream, data,'short');

% close file and return
fclose(stream);
