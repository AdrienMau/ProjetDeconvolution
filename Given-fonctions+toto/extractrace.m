function msddata=extractrace(filename,numfichier,till,saveopt,plottraces,fmim)

%EXTRATRACE.M
%
%function msddata=extractrace(filename,numfichier,till,saveopt,plottraces,fmim)
%
%EXTRACT the msd(t) of each molecule from the files .msd 
%if saveopt=1 
%    store it in 'msd\molecules\FILENAME.moleculei.dat'
%if plottraces=1
%    display all the msd plots
%
%
%FIT every trace
%if saveopt=1  
%    store all the fit results (molecule number, D, dD) in 'msd\fits\FILENAME.fit.dat'
%
%DISPLAY the DIC image with the localization of the molecules from [dicNUMFICHIER.spe]
%DISPLAY the FM image with the accurate localization of each molecule during its whole 
%trace from the image number fmim in [fmNUMFICHIER.spe]
%
%
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

u=0;
  
str=['msd\',filename,'.msd'];
if length(dir(str))>0		
      msddata =load(str);
      SPok=1;
   else
%      disp(['Couldn''t find msd file ',msd]);
      msddata= [];
      SPok=0;
   end
   
str=['trc\',filename,'.trc'];
   if length(dir(str))>0		
      trcdata =load(str);
      SPok=1;
   else
%      disp(['Couldn''t find trc file ',trc]);
      trcdata= [];
      SPok=0;
   end
   
      
   
Lesmax=max(msddata)
Maxtrace=Lesmax(1);
   
disp([' * found ',Num2str(Lesmax(1)),' traces in file ',filename]);

%figure;
ymax=0;

% extrait les traces des fichiers .msd
for i=1:Maxtrace
    temp=[];
    temp(1,:)=[0,0,0,0];
    lesfits=[];
    p=2;
    for j=1:size(msddata(:,1))
            if  msddata(j,1)==i
                temp(p,:)=[msddata(j,1),msddata(j,2)*till,msddata(j,3)-0.05,msddata(j,4)];% -0.05 pour Cy5 et 
                p=p+1;
            else        
        end
    end
    
    sizex=size(temp(:,2));
    maxfit=min(sizex(1),5); %nombre de points fittés, ici au max 5
    [FIT, resFIT]=lsqcurvefit(@pente,0,temp(1:maxfit,2),temp(1:maxfit,3)); %fitte les traces par une droite de pente FIT
    resFIT=sqrt(resFIT)/(2*p)/till; %erreur sur le fit
    
    %conversion en constante de diffusion et de pxl^2/ms en µm^2/s
    FIT=1/4*FIT*1000*0.2^2;
    resFIT=1/4*resFIT*1000*0.2^2;
    
    lesfits(i,:)=[i, FIT, resFIT];
    if resFIT*1000==0
        u=u;
        touslesfits(u+1,:)=[i 0 0];
    else    
        u=1+u
        touslesfits(u,:)=[i, FIT, resFIT];
    end
    
    
    ymax=max(temp(:,2));
    if plottraces==1
        subplot(fix(Maxtrace/2)+1,2,i)
        plot(temp(:,2),temp(:,3),'r:*');
        text(1,0.5*ymax,['trace',Num2str(i), ', fit: ',Num2str(FIT),'+/-',Num2str(resFIT)]); 
    end
        
    if i==1
        text(1,1.5*ymax,filename);
    else
        
    end
    xlabel('x=temps en ms, y=MSD (pxl^2)');

    if saveopt==1
        %sauve les traces individuelles
        save(['msd\molecules\',filename,'.molecule',Num2str(i),'.dat'],'temp','-ascii'); 
        %sauve l'ensemble des fits
        save(['msd\fits\',filename,'.fit.dat'],'lesfits','-ascii');
        save(['msd\fits\',filename,'.fit.dat'],'touslesfits','-ascii');
    end
    
temp=zeros(100,100);
    for itrc=1:Maxtrace
	   ind = find (trcdata(:,1)==itrc);
	    if length(ind)>0
	        temp(max(fix(trcdata(ind,4)),1), max(fix(trcdata(ind,3)),1))=1;
        end
    end 

end
temp=temp(:,1:100);


%namefm=['dic',Num2str(numfichier),'.spe'];
namefm=['goodrhod',Num2str(numfichier),'.spe'];
fm=speread(namefm);
imagefm=fm((fmim-1)*100+1:fmim*100,:);
imagefm=imagefm-min(min(imagefm));
imagefm=abs(imagefm/max(max(imagefm)));
rgbimage2=cat(3,zeros(100,100),imagefm,zeros(100,100));

%namedic=['goodrhod',Num2str(numfichier),'.spe'];
namedic=['dic',Num2str(numfichier),'.spe'];
imagedic=speread(namedic);
%imagedic=imagedic(1:100,:);
imagedic=imagedic-min(min(imagedic));
imagedic=abs(imagedic/max(max(imagedic)));
rgbimage1=cat(3,zeros(100,100),imagedic,temp);



figure;
imshow(rgbimage1);
for itrc=1:Maxtrace
    ind = find (trcdata(:,1)==itrc);
    %ind=28;
	if length(ind)>0
        text(trcdata(ind,3),trcdata(ind,4),'O','Color',[0,1,0],'FontSize',[6]);
	    text(trcdata(ind,3),trcdata(ind,4),Num2str(itrc),'Color',[1,0,0],'FontSize',[6]);
    end
end
figure;
imshow(rgbimage2);Hold on;
hold on;
text(101,102,['numéro de la trace et D (µm^2/s)']);
lesfits=load(['msd\fits\',filename,'.fit.dat']);
text(101,50,[Num2str(lesfits)]);


for itrc=1:Maxtrace
    ind = find (trcdata(:,1)==itrc);
    %ind=28;
	if length(ind)>0
        text(trcdata(ind,3),trcdata(ind,4),'o','Color',[0,0,1],'FontSize',[1]);
	    text(trcdata(ind,3),trcdata(ind,4),Num2str(itrc),'Color',[1,0,0],'FontSize',[6]);
    end
end