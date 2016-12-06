function dolotseq (files,dlat,images)
% input files as prefix to *.* filename
% assumes all should have same dlat = diffusion const.
% assumes all files have same number of images = images
% gab & gsh 
% 07.04.2000
% vers. 1.0 pat. pend.
d = dir([files,'*.*']); 

opts=fitopt([]);
opts(1)= 2;
opts(7)= 2;
opts(9)=2;

for i = 1:size(d,1)
   
   doseq(d(i).name,dlat,images,opts);
   
end   
