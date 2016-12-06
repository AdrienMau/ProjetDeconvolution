function [data] = load_bin(filename)

% LOAD_BIN   Load binary matrix
%
%   Load binary matrix
%
%   SYNTAX
%       [DATA] = LOAD_BIN(FILENAME)
%
%


file = fopen(filename,'r');
dataraw = fread(file,[320 256],'uint32');
fclose(file);


s=size(dataraw);
tx=s(1);
smtx=tx/2;
 data=[];
for i=1:smtx
    data(2*i-1,:)=dataraw(i,:);
    data(2*i,:)=dataraw(i+smtx,:);
end


  