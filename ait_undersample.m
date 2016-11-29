%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function Developed by Fahd A. Abbasi.
% Department of Electrical and Electronics Engineering, University of
% Engineering and Technology, Taxila, PAKISTAN.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The function undersamples an image according with the user requirement.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% USAGE (SAMPLE CODE)
%
%
%       pic = imread('cameraman.tif');
%       pic_usampled = ait_undersample(pic,2);   % 2 times undersampling.  
%       imshow(pic);
%       figure,imshow(pic_usampled);
%       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pic_undersampled] = ait_undersample(pic1,a)

[x,y,z] = size(pic1);

if(z==1)
    pic_undersampled = pic1([1:a:x],[1:a:y]);
else
    pic_undersampled = pic1([1:a:x],[1:a:y],[1:1:z]);
end

