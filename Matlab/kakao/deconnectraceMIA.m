function res=deconnectraceMIA(file,msdflag)

% function res=deconnectraceMIA(file,msdflag) est utilisé dans affectsynapses
% 
% redeconnecte les traces pour les séparer en portions de meme localization (synapse, peri, extra) après avoir appelé connectrace et synapses
% les synapses doivent avoir été affectées aux traces par crées par affectsynapseMIA (extension .spe.MIA.syn.trc)
% créé une nouvelle matrice des traces (trc/cut/file.spe.syn.trc) et les msd correspondants (msd/cut/file.spe.msd)
%
% file: fichier.spe


if nargin<1, help deconnectraceMIA, return, end
if nargin<2, msdflag=0, end

    
global MASCHINE


str=['trc\' ,file, '.MIA.con.syn.trc'];
if length(dir(str))>0		
      Trc =load(str);
end

Ntraceinit=max(Trc(:,1));
Points=size(Trc(:,1),1);

disp([' On a, avant découpage ', Num2str(Ntraceinit), ' traces, soit ', Num2str(Points), ' points.' ]);

nwTrc=Trc;

% découpe
curTrc=nwTrc(4,1);

for i=4:Points-1
    if ((Trc(i,6)==Trc(i-1,6) | Trc(i+1,6)==Trc(i-1,6)) & Trc(i,1)==Trc(i-1,1))
       nwTrc(i,1)=nwTrc(i-1,1);
    else
       if ((Trc(i,6)==Trc(i-2,6) & Trc(i,6)==Trc(i-3,6)) & Trc(i,1)==Trc(i-1,1))
          nwTrc(i,1)=nwTrc(i-1,1);
       else
           if (Trc(i,6)==Trc(i-3,6) & Trc(i,1)==Trc(i-1,1))
              nwTrc(i,1)=nwTrc(i-1,1);
          else
              curTrc=curTrc+1;
              nwTrc(i,1)=curTrc;
          end   
       end
    end
end
nwTrc(Points,1)=nwTrc(Points-1,1);

Trc=nwTrc;
Ntracefinal=max(Trc(:,1));
disp([' Le découpage crée ', Num2str(Ntracefinal), ' traces, soit ', Num2str(Points), ' points.' ]);

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



% résultat final
res=Trc;



if msdflag==1
    disp([' Calcul du MSD...' ]);
    [msddata, fullmsddata]=newMSD(res,150); %%%%%%%%%%% !!! MSD de 150 points au max

    if length(dir('/trc/cut'))==0
        warning off MATLAB:MKDIR:DirectoryExists;
        mkdir('/trc/cut'); mkdir('/msd/cut');
		disp('Les traces et msd coupés sont sauvées dans: /trc/cut and /msd/cut ');
    else           
    end
    save(['trc\cut\',file,'.MIA.deco.syn.trc'],'res','-ascii','-tabs');
    %%%%converti pour msd turbo
            filetxt=['trc\cut\',file,'.MIA.deco.syn.trc'];
            fi = fopen(filetxt,'w');
            if fi<3
              error('File not found or readerror.');
            else
              fprintf(fi,'%6.2f\t %6.2f\t %6.8f\t %6.8f\t %6.2f %6.2f %6.8f\r',res');
            end
            % close
            fclose(fi);
    %%%%%%%%%%fin conversion
    save(['msd\cut\',file,'.MIA.deco.syn.msd'],'msddata','-ascii'); 
else
    if length(dir('/trc/cut'))==0
        warning off MATLAB:MKDIR:DirectoryExists;
   		mkdir('/trc/cut');
		disp('Les traces sont sauvées dans: /trc/cut');
    else           
    end
    save(['trc\cut\',file,'.MIA.deco.syn.trc'],'res','-ascii','-tabs');
    %%%%converti pour msd turbo
            filetxt=['trc\cut\',file,'.MIA.deco.syn.trc'];
            fi = fopen(filetxt,'w');
            if fi<3
              error('File not found or readerror.');
            else
              fprintf(fi,'%6.2f\t %6.2f\t %6.8f\t %6.8f\t %6.2f %6.2f %6.8f\r',res');
            end
            % close
            fclose(fi);
    %%%%%%%%%%fin conversion
    disp('!!! Les msd ne sont pas calculés : il faut l''option msdflag=1 pour les calculer');
end
else
    disp(' !!!!!!!!!!!!!! Résultat: il ne reste plus de trace de longueur suffisante');
end