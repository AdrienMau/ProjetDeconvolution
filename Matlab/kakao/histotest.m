function histotest(option)
%crea histogramas para testear parametros tracking
%llamado desde trackingML
%

if option==1
    column=5;
elseif option==2
    column=4;
elseif option==3
    column=6;
end



resp=1;
   firstentry=1;


% input data
[file,path] = uigetfile('*.pk','Load peak data file');
filename = [path,file];
if file==0
    return
end
y =load(filename);
[filas,col]=size(y);

% histogram
maxval=max(y(:,column));
minval=min(y(:,column));
limsup=maxval;
liminf=minval;
nbins=100;
   

while resp==1       %loop plotting   
    
   [n,xout]=hist(y(:,column),nbins);
   [fil,col]=size(n);
   count=1;
   
   if liminf>min(y(:,5))
       for i=1:col
           if xout(i)>liminf
              xnew(count)=xout(i);
              nnew(count)=n(i);
              count=count+1;
           end
       end
    xout=xnew;
    n=nnew;
   end
   xnew=[];
   nnew=[];
   
   [fil,col]=size(n);
   count=1;
  
   if limsup<max(y(:,5))
       for i=1:col
           if xout(i)<limsup
              xnew(count)=xout(i);
              nnew(count)=n(i);
              count=count+1;
           end
       end
      xout=xnew;
      n=nnew;
   end

   
   figure;

   sizen=max(n)+max(n)/10;
   linf=liminf-liminf/10;
   lsup=limsup+limsup/10;
   %step=mod((lsup-linf),10)
   %tick(1)=step
   %for i=2:10
    %   tick(i)=tick(i-1)+step
    %end
   axis([linf lsup 0 sizen]);
   %set(gca,'XTickLabel',tick)
   bar(xout,n)
   if option==1
       title(['Peaks intensity histogram']);
       xlabel('Intensity'); ylabel('Counts');

   elseif option==2
       title(['Peaks width histogram']);
       xlabel('Width'); ylabel('Counts');

   elseif option==3
       title(['Peaks offset histogram']);
       xlabel('Offset'); ylabel('Counts');

   end


   %hold on

      xnew=[];
   nnew=[];
   
   if firstentry==0
       qstring=['Try again?'];
       button = questdlg(qstring); 
       if strcmp(button,'Yes')
          resp=1;
       else 
          %close 
          break
       end
   end
   
 
   sup=num2str(limsup);
   inf=num2str(liminf);
   bins=num2str(nbins);
   prompt = {['Upper limit (max=',num2str(maxval),')'],['Lower limit (min=',num2str(minval),')'],'Number of bins'};
   num_lines= 1;
   dlg_title = 'Histogram';
   def = {sup,inf,bins}; % default values
   answer  = inputdlg(prompt,dlg_title,num_lines,def);
   exit=size(answer);
   if exit(1) == 0;
       close
       return; 
   end
   
   limsup=str2num(answer{1});
   liminf=str2num(answer{2});
   nbins=str2num(answer{3});

   firstentry=0;
   close
end
