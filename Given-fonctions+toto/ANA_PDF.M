% -----------------------------
% ana_pdf                     -
% -----------------------------
%                             -
% author:gs                   -
% date:  5.12.94              -
%                             -
% syntax: ana_pdf('filename') -                  
% ------------------------------------------------
% ana_pdf evaluates mean_values as well as std   -
%         of intensities belonging to one trace  -
%         and builds up a pdf from those data    -
% ------------------------------------------------


% doing file_work *****************************
function any=ana_pdf(file)
Doit=['load trc\',file];
eval(Doit);
   file1=file(1:length(file)-4);
   A=eval(file1);
Doit=['load pk\',file];
eval(Doit);
   file2=file(1:length(file)-4);
   B=eval(file2);


% looking for trace-starts ********************
diff_A=diff(A(:,1));
   ind=find(diff_A==1)+1;
   ind=[1;ind;length(A(:,1))+1];


% loop over all traces ************************
for trc_num=1:length(ind)-1
   clear int
   trc_max=ind(trc_num+1)-ind(trc_num);


% loop inside one trace ***********************
% looking for peak intensities in pk **********
% evaluation of mean and std ******************
   for trc_len=0:trc_max-1
       x_coord = A(ind(trc_num)+trc_len,3);
       y_coord = A(ind(trc_num)+trc_len,4);
       pic_num = A(ind(trc_num)+trc_len,2);
       pk_ind=find (B(:,2)==x_coord & B(:,3)==y_coord & B(:,1)==pic_num);
       int(trc_len+1)=B(pk_ind,5)*B(pk_ind,4)^2*pi/4/log(2);    
   end
   int_mean(trc_num)=mean(int);
   int_std(trc_num)=std(int);
end


% doing pdf ***********************************
max_int=max(int_mean);
[x,p]=pdf(int_mean,int_std,0,max_int);
plot(x,p)
xlabel 'mean integrated intensity (cnts)'
ylabel 'pdf (1/cnts)'
title (file)


% looking for maxima **************************
dev1=sign(diff(p));
dev2=diff(dev1);
peak=find(dev2==-2)+1;
for i=1:length(peak)
    n=peak(i);
    peak_max=num2str(x(n));
    text (x(n),p(n),peak_max)
end
