function [ clearness ] = is_clear( img,method,param)
%Characterizes the clearness of an image with different methods
%IN:
%   img: image in greyscale
%   method:
% %       1: greyscale level: variance of values, no parameter needed
%         2: Mendelsohn & Mayall: sum pixels higher than parameter ( ! :
%         low clearness = clear  
%         3: Absolute gradient , no parameter needed

%OUT:
%   clearness: a value that gives information avec the clearness.

%By Mau Adrien;
    s=size(img);
    N=s(1)*s(2);
if(method==1)
    clearness=sum(sum(img.*img))/(N^2)-(sum(sum(img)))^2/(N^4);
elseif(method==2)
    clearness=sum(sum(img>param))/N^2;
elseif(method==3)
    clearness=sum(sum(abs(gradient(img))))/N^2;
end

