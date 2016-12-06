% offtime.m
%
% to use:	input:
%				load in trace file using following command to define matrix "a"
%									a = load(tracefile);
%
%				output:
%				save output as ascii file or create histogram from it
%
%
% calculates number of images
% from start of recording to
% image when single molecule appears
%
% Real offtime = offtime * timelag
%
% Follows definition of Peterman et al.
% J. Phys. Chem. A 1999, 103, 10553-10560
% for single GFP blinking

offtime = [];
ind = [];

%a = load(tracefile);

for i = 1:max(a(:,1))
   
   ind = find(a(:,1) == i);
   
   offtime = [offtime; a(ind(1),2)];
   
end