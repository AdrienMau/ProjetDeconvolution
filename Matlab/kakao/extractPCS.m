function msddata=extractPCS(filename,dicfile,till,sizepixel,longFIT)

%extractPCS.M
%
%function msddata=extractPCS(filename,dicfile,till,sizepixel,longFIT)
% fit avec fonction affine
%EXTRACT the msd(t) of each molecule from the files .msd 
%
%    store it in 'msd\molecules\FILENAME.moleculei.dat'
%FIT every trace
%
%    store all the fit results (molecule number, D, dD) in 'msd\fits\FILENAME.fit.dat'
%
%DISPLAY the DIC image with the localization of the molecules from [dicfile.spe]
%
%
global MASCHINE
global BORDER

% check for input parameters

if nargin < 1 % no parameter at all
   help extractrace
   return
end


msddata=[]
trcdata=[];
maxtrc=0;

u=0;
  
%dimension des images
[d p t c]=userdataread(filename);

Xdim=p(1);
Ydim=p(2)/p(4)
clear d, p, t, c;

u=0;
  
%str=['msd\',filename,'.con.msd']
str=[filename,'.msd']
if length(dir('msd'))>0	
      cd msd
      msddata =load(str)
      cd ..
      SPok=1;
      disp(['File ' ,str, ' loaded.']);
else
            disp(['Couldn''t find msd file ',str]);
            msddata= []
            SPok=0;
end

str=[filename,'.trc']
%str=['trc\',filename,'.con.trc']
if length(dir('trc'))>0	
      cd trc
      trcdata =load(str);
      cd ..
      SPok=1;
      disp(['File ' ,str, ' loaded.']);
else
            disp(['Couldn''t find trc file ',str]);
            trcdata= []
            SPok=0;
end   
      
   
Lesmax=max(msddata)
Maxtrace=Lesmax(1);
   
disp([' * found ',Num2str(Lesmax(1)),' traces in file ',filename])

%figure;
ymax=0;

% extrait les traces des fichiers .msd
for i=1:Maxtrace
    temp=[];
    %temp(1,:)=[0,0,0,0];
    lesfits=[];
    p=1;
    for j=1:size(msddata(:,1))
            if  msddata(j,1)==i
                temp(p,:)=[msddata(j,1),msddata(j,2)*till,msddata(j,3),msddata(j,4)];%  
                p=p+1;
            else        
        end
    end
if p>4
    
   
    % début du fit
    sizex=size(temp(:,2));
    maxfit=min(sizex(1),longFIT); %nombre de points fittés, ici au max longFIT
    [F, resFIT]=lsqcurvefit(@affine,[0 0],temp(1:maxfit,2),temp(1:maxfit,3)); %fitte les traces par une droite de pente F(1) et d'offset F(2)
    resFIT=sqrt(resFIT)/(2*p)/till; %erreur sur le fit
    
    FIT=F(1);
    offset=F(2);
    
    %conversion en constante de diffusion et de pxl^2/ms en µm^2/s
    if FIT>=0
       FIT=1/4*FIT*1000*(sizepixel/1000)^2;
   else
       if FIT>=-0.014/(1/4*1000*(sizepixel/1000)^2);
           FIT=0;
       else
       FIT=-1;
   end
   end
    resFIT=1/4*resFIT*1000*(sizepixel/1000)^2;
    
    
    % met les FIT dans un tableau
    lesfits(i,:)=[i, FIT, resFIT,offset*(sizepixel/1000)^2];
    if (resFIT>10^(-10) & FIT>=0)
        u=1+u;
        touslesfits(u,:)=[i, FIT, resFIT,offset*(sizepixel/1000)^2];
    else    
        u=u;
        touslesfits(u+1,:)=[i 0 0 0];
    end
    
    % trace les fits et les msd
    ymax=max(temp(:,2));
        subplot(fix(Maxtrace/2)+1,2,i)
        plot(temp(:,2),temp(:,3),'r:*');
        text(1,0.5*ymax,['trace',Num2str(i), ', fit: ',Num2str(FIT),'+/-',Num2str(resFIT)]); 
        

  

  %%%%%%%%%%%%%sauve les msd individuels
    if length(dir('/msd/molecules'))==0
           % warning off MATLAB:MKDIR:DirectoryExists;
%   		    mkdir('/msd/molecules'); mkdir('/msd/fits');
		    %disp('crée /msd/molecules and /msd/fits ');
    else           
    end
    save(['msd/molecules/',filename,'.con.molecule.',Num2str(i),'.msd.dat'],'temp','-ascii'); 

else%if p>4
end%if p>4          
end %%%%%%%%%%%% fin des fits et de la boucle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%sauve les trc individuelles
if length(dir('/trc/molecules'))==0
            %warning off MATLAB:MKDIR:DirectoryExists;
%   		    mkdir('/trc/molecules')
		    %disp('crée /trc/molecules ');
    else           
    end
MaxPart = max(trcdata(:,1));
for Ipart=1:MaxPart
	iTrc = trcdata(find(trcdata(:,1)==Ipart),2:4);
    save(['trc/molecules/',filename,'.con.molecule.',Num2str(Ipart),'.trc.dat'],'iTrc','-ascii');
end


 %%%%%%%%%%%%%%%%%%%%sauve l'ensemble des fits
if length(dir('/msd/molecules'))==0
            %warning off MATLAB:MKDIR:DirectoryExists;
%   		    mkdir('/msd/molecules'); mkdir('/msd/fits');
		    %disp('crée /msd/molecules and /msd/fits ');
 else           
 end
save(['msd/fits/',filename,'.con.fit.dat'],'touslesfits','-ascii');
        

 
 %%%%%%%%%%%%%%%%%display
temp=zeros(Xdim,Ydim);
    for itrc=1:Maxtrace
	   ind = find (trcdata(:,1)==itrc);
	    if length(ind)>0
	        temp(max(fix(trcdata(ind,4)),1), max(fix(trcdata(ind,3)),1))=1;
        end
    end 
temp=temp(1:Xdim,1:Ydim);


% test si fichier existe:
fid=fopen(dicfile);
if fid==-1
    imagedic=zeros(Ydim,Xdim);
else
imagedic=speread(dicfile);
imagedic=imagedic-min(min(imagedic));
imagedic=abs(imagedic/max(max(imagedic)));
fclose(fid);
end

rgbimage1=cat(3,zeros(Ydim,Xdim),imagedic,zeros(Ydim,Xdim));
figure;
imshow(rgbimage1);

for itrc=1:Maxtrace
    ind = find (trcdata(:,1)==itrc);
    %ind=28;
	if length(ind)>0
       text(trcdata(ind,3),trcdata(ind,4),Num2str(itrc),'Color',[1,0,0],'FontSize',[8]);
    end
end


for itrc=1:Maxtrace
    ind = find (trcdata(:,1)==itrc);
    %ind=28;
	if length(ind)>0
       text(trcdata(ind,3),trcdata(ind,4),Num2str(itrc),'Color',[1,0,0],'FontSize',[8]);
    end
end