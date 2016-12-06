% --------------------------------------------------------
% signois                                                -
% --------------------------------------------------------
%                                                        -
% author:gs                                              -
% date:  10.1.95                                         -
%                                                        -
% syntax: signois('filename1,filename2,...')             -                  
% --------------------------------------------------------
% signois evaluates intensity values as well as std      -
%         of intensities belonging to one trace          -
%         and saves data in consecutive files 'signal.n' -
% --------------------------------------------------------



% definitions *********************************
function any=signois(speicher)

any=[];
int_std=0;
int_mean=0;
va=1;





% doing file_work *****************************
file_ind=[1,find(speicher==',')+1,length(speicher)+2];
for i=1:length(file_ind)-1
      file=speicher(file_ind(i):file_ind(i+1)-2);
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
      clear d_int
      trc_max=ind(trc_num+1)-ind(trc_num);





% loop inside one trace ***********************
% looking for peak intensities in pk **********
% evaluation of mean and std ******************
         for trc_len=0:trc_max-1
             x_coord = A(ind(trc_num)+trc_len,3);
             y_coord = A(ind(trc_num)+trc_len,4);
             pic_num = A(ind(trc_num)+trc_len,2);
             pk_ind=find (B(:,2)==x_coord & B(:,3)==y_coord & B(:,1)==pic_num);
             int(trc_len+1)  =B(pk_ind,5)*B(pk_ind,4)^2*pi/4/log(2);
             d_int(trc_len+1)=sqrt((B(pk_ind,10)/B(pk_ind,5))^2 + (2*B(pk_ind,9)/B(pk_ind,4)^2)) * int(trc_len+1);
   
         end
         C=[int;d_int]';
%         Doit=['save e:/gs/allerlei/signal.',num2str(va),' C /ascii'];
%         eval(Doit);
         any=[any;va*ones(length(C),1),C];
         va=va+1;
 
      end
   end

   

