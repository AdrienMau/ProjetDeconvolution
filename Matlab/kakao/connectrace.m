function [res,resindx]=connectrace(file,maxblink,distmax,minTrace,initialise,diffconst,cutoffs,opt,msd)

% function  [res,resindx]=connectrace(file,maxblink,distmax,minTrace,initialise,diffconst,cutoffs,opt,msd)
%  connecte les traces entre elles.
%        si initialise=1: relance redotracePCSnoMSD(file, diffconst,cutoffs,opt,1,0);
%        Maxblink=durée maximale entre la dernière image et la première des deux traces connectées
%        distmax : distance maximale des molécules (pxl) entre la dernière image et la première des deux traces connectées
%        minTrace : durée minimum des traces que l'on conserve
%  res: nouvelle trace
%  resindx : nouveau fichier Ind 
% si msd=1 recalcule le msd en utilisant newMSD

if nargin<1, help connectrace, return, end
global MASCHINE

if nargin<4
   minTrace=3;
   msd=1;
else 
end

if nargin<5
   initialise=0;
   msd=1;
else 
end

if initialise==1
   disp(['********* On lance redotracePCSnoMSD(file,1, ' num2str(diffconst) ', ' num2str(cutoffs) ' , opt,1,0)']);
   redotracePCSnoMSD(file,diffconst,cutoffs,opt,1,0);
else
   disp('!!! On n''a pas réinitialisé les traces par redotracePCSnoMSD');
end

disp(' ');
if msd==1
    disp('********* On reconnecte les traces : nouveaux fichiers trc/file.spe.con.trc et msd/file.spe.con.msd: ');
else
    disp('********* On reconnecte les traces : nouveaux fichiers trc/file.spe.con.trc mais on ne recalcule pas les msd : ');
end
DoIt  = ['load trc\',file,'.trc'];
eval(DoIt);
TrcName = file(1:find(file=='.')-1);
TrcName(TrcName=='-')='_';	% no '-' in variable names allowed => use '_' instead
Trc=eval(TrcName);
Ntraceinit=max(Trc(:,1));

str=['pk\',file,'.pk'];
      if length(dir(str))>0		% is there new peakdata?
      pkdata =load(str);
      else
      pkdata=[];
      end

str=['ind\',file,'.ind'];
   if length(dir(str))>0		% is there new indexdata? 
      IndexTrc=load(str);
      SIok=1;
	else
      IndexTrc=[];
    end

nwIdx=[];

clear a;
clear b;
Nt(1)=Ntraceinit+1;

for h=1:Ntraceinit

Points=size(Trc(:,1),1);
Ntrace=max(Trc(:,1));
Nt(h+1)=Ntrace;

if Nt(h+1)~=Nt(h)

Points;
Ntrace;

% trouve les début et fin de trace
dfTrc=[];
dfTrc=[dfTrc;[1,Trc(1,:)]];
for i=2:Points-1
    if Trc(i,1)-Trc(i-1,1)==1
    dfTrc=[dfTrc;[i,Trc(i,:)]];
    else
        if Trc(i+1,1)-Trc(i,1)==1
        dfTrc=[dfTrc;[i,Trc(i,:)]];
        end
    end
end
dfTrc=[dfTrc;[Points,Trc(Points,:)]];

% trouve les débuts de trace
debTrc=[];
debTrc=[debTrc;Trc(1,:)];
for i=2:Points
    if Trc(i,1)-Trc(i-1,1)==1
    debTrc=[debTrc;Trc(i,:)];
    else
    end
end

% trouve les fins de trace
finTrc=[];
for i=1:Points-1
    if Trc(i+1,1)-Trc(i,1)==1
       finTrc=[finTrc;Trc(i,:)];
    end
end
finTrc=[finTrc;Trc(Points,:)];
Ntrace=size(finTrc(:,1),1);


% crée la matrice des distances
Dist=zeros(Ntrace,Ntrace);
Dist=Dist+100;
for i=1:Ntrace
    for j=1:Ntrace
        if (j>i & finTrc(i,2)<debTrc(j,2))
           Dist(i,j)=sqrt((finTrc(i,3)-debTrc(j,3))^2+(finTrc(i,4)-debTrc(j,4))^2);
        else
        end
    end
end

%crée la matrice des distances minimum entre traces: IdxLesmin contient les indices des traces et les valeurs des distances
Lesmin=zeros(Ntrace,1);
IdxLesmin=[];
for i=1:Ntrace-1
    lespi=find((Dist(i,:)<distmax));
    if ~isempty(lespi)
        lepi=min(lespi);
        Lesmin(i)=Dist(i,lepi);
    else 
        Lesmin(i)=100;
    end
end
Lesmin(Ntrace)=100;

for i=1:Ntrace
    for j=1:Ntrace
        if (Dist(i,j)==Lesmin(i) & Dist(i,j)<100) 
            IdxLesmin=[IdxLesmin;[i,j,Lesmin(i)]]; 
        else
            if (Dist(i,j)==Lesmin(i) & i==j & Dist(i,j)==100)
               IdxLesmin=[IdxLesmin;[i,i,100]]; 
            else
            end
        end
    end
end

IdxLesmin;
temp=Trc;

%Ntrace=size(IdxLesmin(:,1),1)
nwTrc=[];


%test les connections valides. Sinon, connecte la trace avec elle meme
for i=1:Ntrace
    if ((debTrc(IdxLesmin(i,2),2)-finTrc(IdxLesmin(i,1),2))>maxblink | IdxLesmin(i,3)>distmax)
        IdxLesmin(i,2)=IdxLesmin(i,1);
    else
    end
end    

IdxLesmin;

%construit la nouvelle matrice des traces 
for i=1:Ntrace%-1
    nwIdx(i,1)=i;
    if IdxLesmin(i,2)~=IdxLesmin(i,1)
        debuttrace1=dfTrc(2*IdxLesmin(i,1)-1,1); %
        fintrace1=dfTrc(2*IdxLesmin(i,1),1);
        debuttrace2=dfTrc(2*IdxLesmin(i,2)-1,1);
        fintrace2=dfTrc(2*IdxLesmin(i,2),1);
        for k=debuttrace1:fintrace1
            if temp(k,1)==0
            else
                nwTrc=[nwTrc;[i,temp(k,:)]];
                temp(k,1)=0;
            end
        end
        for k=debuttrace2:fintrace2
            if temp(k,1)==0
            else
                nwTrc=[nwTrc;[i,temp(k,:)]];
                temp(k,1)=0;
            end
        end
    else
        debuttrace1=dfTrc(2*IdxLesmin(i,1)-1,1); %
        fintrace1=dfTrc(2*IdxLesmin(i,1),1);
        for k=debuttrace1:fintrace1
            if temp(k,1)==0
            else
                nwTrc=[nwTrc;[i,temp(k,:)]];
                temp(k,1)=0;
            end
        end    
    end
end

%renumérote les nouvelles traces sans chiffre manquant
Points=size(nwTrc(:,1),1);
tmp=[];
tmp(1)=nwTrc(1,1);
for i=2:Points
    if (nwTrc(i,1)-nwTrc(i-1,1))>0
       tmp(i)=tmp(i-1)+1;
    else
        tmp(i)=tmp(i-1);
    end
end
for i=2:Points
    nwTrc(i,1)=tmp(i);
end

%sépare réinitialise la trace
clear Trc;
Trc(:,1)=nwTrc(:,1);
Trc(:,2)=nwTrc(:,3);
Trc(:,3)=nwTrc(:,4);
Trc(:,4)=nwTrc(:,5);
Trc(:,5)=nwTrc(:,6);

end %fin du if dans de la boucle sur Nt(h)

end % fin de la boucle sur Nt(h)

% sélectionne les traces de longueur supérieure à minTrace
    inddata=traceind(pkdata,Trc);
    ntrclen=sum(inddata(:,2:end)>0,2);
    nTraceData=[];
    Ntracetmp=max(Trc(:,1));
    for i=1:Ntracetmp
            if ntrclen(i)>=minTrace %keeps the traces >= minTrace
                k=Trc(Trc(:,1)==i,:);
                nTraceData=[nTraceData;k]; 
            else 
            end
    end
    Trc=nTraceData;

if size(Trc)>0    
%renumérote les nouvelles traces sans chiffre manquant
Points=size(Trc(:,1),1);
tmp=[];
tmp(1)=Trc(1,1);
for i=2:Points
    if (Trc(i,1)-Trc(i-1,1))>0
       tmp(i)=tmp(i-1)+1;
    else
        tmp(i)=tmp(i-1);
    end
end
for i=1:Points
    Trc(i,1)=tmp(i)-tmp(1)+1;
end


%crée les indices
nwIdx=traceind(pkdata,Trc);

resindx=nwIdx;
res=Trc;

Ntracefin=max(Trc(:,1));
disp([Num2str(Ntraceinit) ' traces au départ.']);
disp([Num2str(Ntracetmp) ' traces après reconnection.']);
disp(['Finalement, ' Num2str(Ntracefin) ' traces après filtrage des traces trop courtes (inférieures à ' Num2str(minTrace) ' points).']);
disp(' ');
%recalcule le msd si msd==1

if Ntracefin>0

%save everything
save(['trc\',file,'.con.trc'],'res','-ascii','-tabs');

%%%%converti pour msd turbo
            filetxt=['trc\',file,'.con.trc'];
            fi = fopen(filetxt,'w');
            if fi<3
              error('File not found or readerror.');
            else
              fprintf(fi,'%6.2f\t %6.2f\t %6.8f\t %6.8f\t %6.8f\r',res');
            end
            % close
            fclose(fi);
%%%%%%%%%%fin conversion

save(['ind\',file,'.con.ind'],'resindx','-ascii'); 
    
if msd==1
    [msddata, fullmsddata]=newMSD(Trc,150); %%%%%%%%%%% !!! MSD de 150 points au max
    save(['msd\',file,'.con.msd'],'msddata','-ascii');  
else
end

end
else
    disp(' !!!!!!!!!!!!!! Résultat: il ne reste plus de trace de longueur suffisante');
end
