function msddata=extractsynPCSMIA(filename,synfile,dicfile,till,sizepixel,longFIT)

%extractracePCS.M
%
%function msddata=extractracePCS(filename,synfile,dicfile,till,sizepixel,longFIT)
% fit avec fonction affine les traces affectées aux localisations par affectsynapses
% paramètres:
%       filename : fichier.spe
%       synfile : fichier de synapse_MIA.spe
%       dicfile : fichier dic.spe
%       till : temps entre deux images
%       sizepixel : taille des pixels en nm
%       longFIT : nombre de points sur lesquels les fits sont faits
%EXTRACT the msd(t) of each molecule from the files cut.msd 
%    store it in 'cut\msd\molecules\FILENAME.moleculei.dat'
%FIT every trace
%    store all the fit results (molecule number, D, dD, syn) in '\cutmsd\fits\FILENAME.fit.dat'

global MASCHINE
global BORDER

% check for input parameters

if nargin < 1 % no parameter at all
   help extractrace
   return
end


msddata=[];
trcdata=[];
maxtrc=0;

%dimension des images
[d p t c]=userdataread(filename);

Xdim=p(1);
Ydim=p(2)/p(4);
clear d, p, t, c;

u=0;
  
str=['msd\cut\',filename,'.MIA.deco.syn.msd'];
if length(dir(str))>0		
      msddata =load(str);
      SPok=1;
      disp(['File ' ,str, ' loaded.']);
else
            disp(['Couldn''t find msd file ',str]);
            msddata= [];
            SPok=0;
end

str=['trc\cut\',filename,'.MIA.deco.syn.trc'];
if length(dir(str))>0		
      trcdata =load(str);
      SPok=1;
      disp(['File ' ,str, ' loaded.']);
else
            disp(['Couldn''t find trc file ',str]);
            trcdata= []
            SPok=0;
end

Lesmax=max(msddata);
Maxtrace=Lesmax(1);
   
disp([' * found ',Num2str(Lesmax(1)),' traces in file ',filename, ', et trace la plus longue:' ,Num2str(Lesmax(2)), ' points.'] );

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
                temp(p,:)=[msddata(j,1),msddata(j,2)*till,msddata(j,3),msddata(j,4)];
                p=p+1;
            else        
        end
    end
    
 if p>4       
    % début du fit
    if size(temp)>0
        sizex=size(temp(:,2));
        maxfit=min(sizex(1),longFIT); %nombre de points fittés, ici au max longFIT
        [F, resFIT]=lsqcurvefit(@affine,[0 0],temp(1:maxfit,2),temp(1:maxfit,3)); %fitte les traces par une droite de pente F(1) et d'offset F(2)
        resFIT=sqrt(resFIT)/(2*p)/till; %erreur sur le fit
    
        FIT=F(1)
        offset=F(2);
    else
        FIT=-100;
        offset=-100;
    end
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
    
    indsyn = find (trcdata(:,1)==i);% trouve les positions de la trace dans trcdata
    
    % met les FIT dans un tableau
    lesfits
    lesfits(i,:)=[i, FIT, resFIT,offset*(sizepixel/1000)^2,trcdata(indsyn(1),6)]; % ajoute en dernière colonne la localisation (# syn, -1: peri, 0: extra
    if (resFIT>10^(-10) & FIT>=0)
        u=1+u;
        touslesfits(u,:)=[i, FIT, resFIT,offset*(sizepixel/1000)^2,trcdata(indsyn(1),6)];
    else    
        u=u;
        touslesfits(u+1,:)=[i 0 0 0 0];
    end
    
    
    % trace les fits et les msd
    if size(temp)>0
        ymax=max(temp(:,2));
        subplot(fix(Maxtrace/2)+1,2,i)
        plot(temp(:,2),temp(:,3),'r:*');
        text(1,0.5*ymax,['trace',Num2str(i), ', fit: ',Num2str(FIT),'+/-',Num2str(resFIT)]);    
    else
    end


    
    
    %%%%%%%%%%%%%sauve les msd individuels
    if length(dir('/msd/cut/molecules'))==0
            warning off MATLAB:MKDIR:DirectoryExists;
   		    mkdir('/msd/cut/molecules'); mkdir('/msd/cut/fits');
		    %disp('crée /msd/molecules and /msd/fits ');
    else           
    end
    save(['msd\cut\molecules\',filename,'.MIA.deco.molecule.',Num2str(i),'.msd.dat'],'temp','-ascii'); 

else%if p>4
end%if p>4          
end %%%%%%%%%%%% fin des fits et de la boucle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%sauve les trc individuelles
if length(dir('/trc/cut/molecules'))==0
            warning off MATLAB:MKDIR:DirectoryExists;
   		    mkdir('/trc/cut/molecules')
		    %disp('crée /trc/cut/molecules ');
    else           
    end
MaxPart = max(trcdata(:,1));
for Ipart=1:MaxPart
	iTrc = trcdata(find(trcdata(:,1)==Ipart),2:4);
    save(['trc\cut\molecules\',filename,'.MIA.deco.molecule.',Num2str(Ipart),'.trc.dat'],'iTrc','-ascii');
end


 %%%%%%%%%%%%%%%%%%%%sauve l'ensemble des fits
 
touslesfits=sortrows(touslesfits,5)
if length(dir('/msd/cut/molecules'))==0
            warning off MATLAB:MKDIR:DirectoryExists;
   		    mkdir('/msd/cut/molecules'); mkdir('/msd/cut/fits');
		    %disp('crée /msd/molecules and /msd/fits ');
 else           
 end
save(['msd\cut\fits\',filename,'.MIA.deco.fit.dat'],'touslesfits','-ascii');

 
 %%%%%%%%%%%%%%%%%%display   
    
temp=zeros(Xdim,Ydim);
    for itrc=1:Maxtrace
	   ind = find (trcdata(:,1)==itrc);
	    if length(ind)>0
	        temp(max(fix(trcdata(ind,4)),1), max(fix(trcdata(ind,3)),1))=1;
        end
    end 


temp=temp(1:Xdim,1:Ydim);

imagefm=speread(synfile);
imagefm=imagefm-min(min(imagefm));
imagefm=abs(imagefm/max(max(imagefm)));
%rgbimage2=cat(3,zeros(Ydim,Xdim),imagefm,zeros(Ydim,Xdim));
[qw, qx, rgbimage2]=synapses(synfile);

imagedic=speread(dicfile);
imagedic=imagedic-min(min(imagedic));
imagedic=abs(imagedic/max(max(imagedic)));
rgbimage1=cat(3,zeros(Ydim,Xdim),imagedic,zeros(Ydim,Xdim));

figure;
imshow(rgbimage1);
for itrc=1:Maxtrace
    ind = find (trcdata(:,1)==itrc);
    if length(ind)>0
       text(trcdata(ind,3),trcdata(ind,4),Num2str(itrc),'Color',[1,0,0],'FontSize',[8]);
    end
end
figure;
imshow(rgbimage2);Hold on;
hold on;



for itrc=1:Maxtrace
    ind = find (trcdata(:,1)==itrc);
    %ind=28;
	if length(ind)>0
       text(trcdata(ind,3),trcdata(ind,4),Num2str(itrc),'Color',[0,1,0],'FontSize',[8]);
    end
end