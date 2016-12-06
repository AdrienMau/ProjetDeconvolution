function res=connectraceMIA(file,maxblink,distmax,minTrace,msd,filtre)

% function  res=connectraceMIA(file,maxblink,distmax,minTrace,msd, filtre)
%  connecte les traces entre elles.
%        Maxblink=durée maximale entre la dernière image et la première des deux traces connectées
%        distmax : distance maximale des molécules (pxl) entre la dernière image et la première des deux traces connectées
%        minTrace : durée minimum des traces que l'on conserve
%        filtre=1 filtre les traces de 1 points
%  res: nouvelle trace
% si msd=1 recalcule le msd en utilisant newMSD

if nargin<1, help connectraceMIA, return, end
global MASCHINE

if nargin<4
   minTrace=3;
   msd=0;
else 
end


disp(['!!! MinTrace :' num2str(minTrace)]);
disp('********* On reconnecte les traces (ce qui créé les fichiers trc/file.MIA.con.trc et msd/file.MIA.con.msd: ');


str  = ['trc\',file,'_MIA.trc'];
TrcInit=load(str);

%%%%%%%%%%%%%%%%%%%%%enlève les traces de 1 point
if filtre ==1
    Points=size(TrcInit(:,1),1);
    Ntrace=max(TrcInit(:,1));
    tempTrc=[];
    tempTrc=[tempTrc;[TrcInit(1,:)]];
    for i=2:Points-1
        if (TrcInit(i,1)-TrcInit(i-1,1)==1 & TrcInit(i+1,1)-TrcInit(i,1)==1)
        else
         tempTrc=[tempTrc;[TrcInit(i,:)]];
        end
    end
    if TrcInit(Points,1)-TrcInit(Points-1,1)==1
    else
        tempTrc=[tempTrc;[TrcInit(Points,:)]];
    end
    %renumérote les nouvelles traces sans chiffre manquant
    Points=size(tempTrc(:,1),1);
    tmp=[];
    tmp(1)=tempTrc(1,1);
    for i=2:Points
        if (tempTrc(i,1)-tempTrc(i-1,1))>0
           tmp(i)=tmp(i-1)+1;
        else
            tmp(i)=tmp(i-1);
        end
    end
    for i=2:Points
        tempTrc(i,1)=tmp(i);
    end
    TrcInit=tempTrc;
    Ntracefinal=max(TrcInit(:,1));
    disp(['On a filtré ' Num2str(Ntrace-Ntracefinal), ' traces de 1 point générées par MIA.']);

else 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%On va maintenant travailler sur une matrice allégée des traces qui ne contient que les débuts et fins des traces
Points=size(TrcInit(:,1),1);
Ntrace=max(TrcInit(:,1));

TrcShort=[];
TrcShort=[TrcShort;[TrcInit(1,:),1]];
for i=2:Points-1
    if (TrcInit(i,1)-TrcInit(i-1,1)==0 & TrcInit(i+1,1)-TrcInit(i,1)==0)
    else
    TrcShort=[TrcShort;[TrcInit(i,:),i]];
    end
end
TrcShort=[TrcShort;[TrcInit(Points,:),Points]];
%
Trc=TrcShort;
NPoints=size(Trc(:,1),1);
%Trc
disp(['On travaille sur ' Num2str(NPoints), ' points, au lieu de ' Num2str(Points), ' en n''utilisant que les débuts et fins de traces']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% début de la reconnection

Ntraceinit=max(Trc(:,1));

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
disp(['Numéro de la passe : ' Num2str(h)]);


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
        clear lepi;
        clear lespi;
    else 
        Lesmin(i)=100;
    end
end

Lesmin(Ntrace)=100;
%Lesmin

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
Trc(:,6)=nwTrc(:,7);
Trc(:,7)=nwTrc(:,8);

clear nwTrc
end %fin du if dans de la boucle sur Nt(h)

end % fin de la boucle sur Nt(h)

disp(['Patience ! Avancement de l''écriture de la matrice finale de traces ... ']);

% sélectionne les traces de longueur supérieure à minTrace
Ntracereconnect=max(Trc(:,1));
Np=NPoints/2;
numTrace=1;
longTrc=0;
tempoTrc=[];
tempo=[];
longTrc=zeros(Ntrace,2); %%% va contenir le numéro de la trace et la longueur de la trace


for i=1:Np
longTrc(numTrace,1)=numTrace;
    if Trc(2*i,1)==numTrace
    longTrc(numTrace,2)=longTrc(numTrace,2)+Trc(2*i,7)-Trc(2*i-1,7)+1;
    else
    numTrace=numTrace+1;
    longTrc(numTrace,2)=longTrc(numTrace,2)+Trc(2*i,7)-Trc(2*i-1,7)+1;
    
    end
end
longTrc(Ntrace,1)=Ntrace;
%longTrc
%longTrc : matrice de la longueur des traces

for i=1:NPoints
    if longTrc(Trc(i,1),2)>minTrace
       tempoTrc=[tempoTrc;[Trc(i,:)]];
   else
   end
end
       
Trc=tempoTrc;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
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


%%%%%%%%%%%%%%%%refabrique la matrice complète des traces à partir de trace

NPoints=size(Trc(:,1),1);
Np=NPoints/2;
fullTrc=[];
for i=1:Np
    debut=Trc(2*i-1,7);
    fin=Trc(2*i,7);
    for j=debut:fin
        fullTrc=[fullTrc;[Trc(2*i-1,1),TrcInit(j,2:6)]];
    end
end
disp(['On récupère ' Num2str(size(fullTrc(:,1),1)), ' points qui constituent les traces de départ, après filtrage des traces trops courtes.']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%resindx=nwIdx;
res=fullTrc;

Ntracefin=max(fullTrc(:,1));
disp([Num2str(Ntraceinit) ' traces au départ.']);
disp([Num2str(Ntracereconnect) ' traces après reconnection.']);
disp(['Finalement, ' Num2str(Ntracefin) ' traces après filtrage des traces trop courtes (inférieures à ' Num2str(minTrace) ' points).']);
disp(' ');

if Ntracefin>0

%save everything
if length(dir('/trc'))==0
        warning off MATLAB:MKDIR:DirectoryExists;
        mkdir('/trc'); 
    else           
    end
save(['trc\',file,'.spe.MIA.con.trc'],'res','-ascii','-tabs'); 

%%%%converti pour msd turbo
            filetxt=['trc\',file,'.spe.MIA.con.trc'];
            fi = fopen(filetxt,'w');
            if fi<3
              error('File not found or readerror.');
            else
              fprintf(fi,'%6.2f\t %6.2f\t %6.8f\t %6.8f\t %6.8f %6.8f\r',res');
            end
            % close
            fclose(fi);
%%%%%%%%%%fin conversion


%recalcule le msd si msd==1

if msd==1
    if length(dir('/msd'))==0
        warning off MATLAB:MKDIR:DirectoryExists;
        mkdir('/msd');
		disp('Calcul du MSD qui sont sauvés dans /msd ');
    else           
    end
    
    [msddata, fullmsddata]=newMSD(res,150); %%%%%%%%%%% !!! MSD de 150 points au max
    save(['msd\',file,'.spe.MIA.con.msd'],'msddata','-ascii'); 
else
end

end
else
    disp(' !!!!!!!!!!!!!! Résultat: il ne reste plus de trace de longueur suffisante');
end
