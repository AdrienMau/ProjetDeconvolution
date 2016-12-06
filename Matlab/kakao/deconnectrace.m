function res=deconnectrace(file,msdflag,minTrace)

% function res=deconnectrace(file,msdflag,minTrace) est utilis� dans affectsynapses
% 
% redeconnecte les traces pour les s�parer en portions de meme localization (synapse, peri, extra) apr�s avoir appel� connectrace et synapses
% les synapses doivent avoir �t� affect�es aux traces par cr�es par affectsynapse (extension .spe.syn.trc)
% cr�� une nouvelle matrice des traces (trc/cut/file.spe.syn.trc) et les msd correspondants (msd/cut/file.spe.msd)
%
% file: fichier.spe


if nargin<1, help deconnectrace, return, end
if nargin<2, msdflag=0, end
if nargin<3, minTrace=3, end
    
global MASCHINE

%DoIt  = ['load trc\',file,'.syn.trc'];

str=['trc\',file,'.con.syn.trc'];
if length(dir(str))>0		
      Trc =load(str);
end

str=['pk\',file,'.pk'];
      if length(dir(str))>0
      pkdata =load(str);
      end

Ntraceinit=max(Trc(:,1));
Points=size(Trc(:,1),1);

disp([' On a, avant d�coupage ', Num2str(Ntraceinit), ' traces, soit ', Num2str(Points), ' points.' ]);

nwTrc=Trc;

% d�coupe
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


Ntracefinal=max(nwTrc(:,1));
disp([' Le d�coupage cr�e ', Num2str(Ntracefinal), ' traces, soit ', Num2str(Points), ' points.' ]);

Trc=nwTrc;
% s�lectionne les traces de longueur sup�rieure � minTrace
    inddata=traceind(pkdata,Trc(:,1:5)); % Trc(:,1:5): traces sans synapse
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
%renum�rote les nouvelles traces sans chiffre manquant
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


%cr�e les indices
nwIdx=traceind(pkdata,Trc(:,1:5));

% r�sultat final
resindx=nwIdx;
res=Trc;

Ntracefin=max(Trc(:,1));
disp(['Finalement, il reste ' Num2str(Ntracefin) ' traces de longueur sup�rieure � ' Num2str(minTrace) ' points).']);
disp(' ');


if msdflag==1
    [msddata, fullmsddata]=newMSD(res,150); %%%%%%%%%%% !!! MSD de 150 points au max

    if length(dir('/trc/cut'))==0
        warning off MATLAB:MKDIR:DirectoryExists;
        mkdir('/trc/cut'); mkdir('/msd/cut');
		disp('Les traces et msd coup�s sont sauv�es dans: /trc/cut and /msd/cut ');
    else           
    end
    save(['trc\cut\',file,'.deco.syn.trc'],'res','-ascii'); 
    save(['msd\cut\',file,'.deco.syn.msd'],'msddata','-ascii'); 
    %%%%converti pour msd turbo
            filetxt=['trc\cut\',file,'.deco.syn.trc'];
            fi = fopen(filetxt,'w');
            if fi<3
              error('File not found or readerror.');
            else
              fprintf(fi,'%6.2f\t %6.2f\t %6.8f\t %6.8f\t %6.8f\t %6.2f\r',res');
            end
            % close
            fclose(fi);
    %%%%%%%%%%fin conversion

else
    if length(dir('/trc/cut'))==0
        warning off MATLAB:MKDIR:DirectoryExists;
   		mkdir('/trc/cut');
		disp('Les traces sont sauv�es dans: /trc/cut');
    else           
    end
    save(['trc\cut\',file,'.deco.syn.trc'],'res','-ascii'); 
    %%%%converti pour msd turbo
            filetxt=['trc\cut\',file,'.deco.syn.trc'];
            fi = fopen(filetxt,'w');
            if fi<3
              error('File not found or readerror.');
            else
              fprintf(fi,'%6.2f\t %6.2f\t %6.8f\t %6.8f\t %6.8f\t %6.2f\r',res');
            end
            % close
            fclose(fi);
    %%%%%%%%%%fin conversion
    disp('!!! Les msd ne sont pas calcul�s : il faut l''option msdflag=1 pour les calculer');
end
else
    disp(' !!!!!!!!!!!!!! R�sultat: il ne reste plus de trace de longueur suffisante');
end