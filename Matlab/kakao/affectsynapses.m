function [nwtrcsyn, nwtrccut]=affectsynapses(file, synfile,maxblink,distmax,minTrace,init,opts,deco,diffconst,cutoffs)

% function [nwtrcsyn, nwtrccut]=affectsynapses(file.spe, synfile,maxblink,distmax,minTrace,init,opts,deco,diffconst,cutoffs)
% créé une nouvelle matrice des traces (nwtrcsyn) avec dans la 6eime colonne le numéro de la synapse dans laquelle est la molécule
% de type .spe.syn.trc
%
% appelle connectrace pour connecter les traces entre elles
% file.spe.trc -> file.spe.con.trc
% appelle synapses pour numéroter les synapses
% si deco==1 appelle deconnectrace qui crée des traces (nwtrccut) en fonction de leurs localisation et les sauve dans trc/cut... et mad/cut...
% file: fichier.spe
% filesynapse: file.mito_MIA.spe
% maxblink: nombre maximum du bliking en images
% distmax: distance maximale de connection en pixels
% minTrace : durée minimum des traces que l'on conserve

if nargin<1, help affectsynapses, return, end

if nargin<5, minTrace=3, end
if nargin<7, init=0, end
if nargin<8, deco=0, end

trcdata=[];
strFile=file;
strSyn=synfile;

%files=sbe(file,0);%%%%%%%%j'ai mis 0 à la place de 1 pour le faire marcher avec file et non file.spe
%for k=1:length(files)
%   strFile=[files(k).name,'.spe'];
%   strSyn=[files(k).name,'-mito_MIA.spe'];
%   disp(['Fichiers actuels: ', strFile, ' et ', strSyn]);
%      if length(dir(strFile))>0		% is there new peakdata?
      
%dimension des images
%disp('Size of synapse file:');
[d p t c]=userdataread(strSyn);
Xdim=p(1);
Ydim=p(2)/p(4);
clear d, p, t, c;
nwtrccut=[];

if init==1
    [Trc,Trcindx]=connectrace(strFile,maxblink,distmax,minTrace,1,diffconst,cutoffs,opts,1);
    else
    [Trc,Trcindx]=connectrace(strFile,maxblink,distmax,minTrace);
end
[maximas, numsynapse, img]=synapses(strSyn);

Points=size(Trc(:,1),1);

temp=[];
for i=1:Points
    temp=[temp;[Trc(i,:),numsynapse(max(min(round(Trc(i,4)+1),Ydim),1),max(min(round(Trc(i,3)+1),Xdim),1))]]; % ! x et y sont inversé dans numsynapse par rapport à Trc
end
nwtrcsyn=temp;
save(['trc\',strFile,'.con.syn.trc'],'temp','-ascii','-tabs'); 

%%%%converti pour msd turbo
            filetxt=['trc\',file,'.con.syn.trc'];
            fi = fopen(filetxt,'w');
            if fi<3
              error('File not found or readerror.');
            else
              fprintf(fi,'%6.2f\t %6.2f\t %6.8f\t %6.8f\t %6.8f\t %6.2f\r',temp');
            end
            % close
            fclose(fi);
%%%%%%%%%%fin conversion

disp('On sauve les traces avec localization synaptique dans \trc\file.spe.con.syn.trc')

if deco==1
    disp(' ');
    disp('********* On decoupe les traces en fonction de la localisation (deconnectrace) et calcule les msd')
    nwtrccut=deconnectrace(strFile,1,minTrace);
else
end

%else
%      StrFile=[];
%      end
%  end



