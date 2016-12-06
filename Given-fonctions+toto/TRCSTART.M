%-----------
% trcstart -
%-----------
% trcstart('filename1,filename2,...',seq)
%
%-----------------------

function start_trc=trcstart(speicher,nx)
start_trc=zeros(1,nx);
file_ind=[1,find(speicher==',')+1,length(speicher)+2]
for i=1:length(file_ind)-1
   file=speicher(file_ind(i):file_ind(i+1)-2)
   Doit =['load trc\',file];
   eval(Doit);
   file=file(1:length(file)-4)
   A=eval(file);
   A(:,2)=rem(A(:,2),nx);
   diff_A=diff(A(:,1));
   ind=find(diff_A==1)+1;
   ind=[1;ind];
   [y,x]=hist(A(ind,2),1:nx);
   start_trc=start_trc+y;
end
bar(start_trc)
xlabel('picture index'),ylabel('occurence')
title('trace starting at picture index')

