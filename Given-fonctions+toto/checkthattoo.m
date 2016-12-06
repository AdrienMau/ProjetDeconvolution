function h=checkthattoo(filename, till, cutoffs)
% CheckThatToo (filename, till, cutoffs)
% --
% reads peakfile <filename> (taken with <till>ms illumination) and
% removes all points not confiming to <cutoffs>.
% currently cutoffs consist of a rowvector [ RelavtiveError MaxCounts ]
% --
% Version 1.0 11/7/2000 by GAB
% --

if nargin < 1
   help checkthattoo
   return
end

if nargin < 3
   cutoffs = [1/3 1000];
	disp('Set default cutoff values 1/3 relErr & 1000 cntsMax');
  
	if nargin < 2
      till=5;
   	disp('Set default illumination 5ms');
   end
end

clear f;
%clear h;
clear indi;
cd pk
data=load(filename);
cd ..
indi = find(data(:,10)<(data(:,5)*cutoffs(1)) & data(:,5)> 0 & data(:,5)< cutoffs(2)) ;

h = data(indi,:);
h(:,5) = h(:,5)/till;
h(:,10) = h(:,10)/till;

[x,y] = pdf_old(h(:,5),h(:,10),0,1000); plot(x,y)
%[x,y] = pdf_old(h(:,5),h(:,10),50,1000);plot(x,y)
title(filename);
x(find(y==max(y)))
mean(h(:,5))
size(h(:,5))
%a = x'; b= y';
%save c4lc100check h;
%save c4lc100.data h -ascii;
DoIt  = ['save ', filename,'.dat h -ascii'];
eval (DoIt);
DoIt  = ['save ', filename,'.bin h'];
eval (DoIt);
