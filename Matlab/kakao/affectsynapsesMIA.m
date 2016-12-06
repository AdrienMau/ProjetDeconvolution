function [nwtrcsyn, nwtrccut]=affectsynapsesMIA(file,filesynapse,maxblink,distmax,minTrace,deco,msdflag)

% function [nwtrcsyn, nwtrccut]=affectsynapsesMIA(file,filesynapse,maxblink,distmax,minTrace,deco,msdflag)
% cr�� une nouvelle matrice des traces (nwtrcsyn) avec dans la 6eime colonne le num�ro de la synapse dans laquelle est la mol�cule
% de type .spe.syn.trc, dans la 5i�me, il y a les intensit�s et dans la
% 7i�me les largeurs des pics
%
% appelle connectraceMIA pour connecter les traces entre elles
% appelle synapses pour num�roter les synapses
% si deco==1 appelle deconnectrace qui cr�e des traces (nwtrccut) en fonction de leurs localisation et les sauve dans trc/cut... et mad/cut...
% si msdflag=1, calcule le newMSD dans deconnectrace, msdfalg= 1 par d�faut
% file: fichier.spe
% filesynapse: fichier_MIA.spe
% maxblink: nombre maximum du bliking en images
% distmax: distance maximale de connection en pixels
% minTrace : dur�e minimum des traces que l'on conserve

if nargin<1, help affectsynapses, return, end
global MASCHINE
if nargin<4, minTrace=3, end
if nargin<6, deco=0, end
if nargin<7, msdflag=1, end

%dimension des images
disp('Size of synapse file:');
[d p t c]=userdataread(filesynapse);
Xdim=p(1);
Ydim=p(2)/p(4);
clear d, p, t, c;
nwtrccut=[];
strFile=[file,'.spe'];

Trc=connectraceMIA(file,maxblink,distmax,minTrace,msdflag,1);
    
[maximas, numsynapse, img]=synapses(filesynapse);

Points=size(Trc(:,1),1);

temp=[];
for i=1:Points
    temp=[temp;[Trc(i,1:5),numsynapse(max(min(round(Trc(i,4)+1),Ydim),1),max(min(round(Trc(i,3)+1),Xdim),1)),Trc(i,6)]]; % ! x et y sont invers� dans numsynapse par rapport � Trc
end
nwtrcsyn=temp;
save(['trc\',strFile,'.MIA.con.syn.trc'],'temp','-ascii','-tabs'); 

%%%%converti pour msd turbo
            filetxt=['trc\',strFile,'.MIA.con.syn.trc'];
            fi = fopen(filetxt,'w');
            if fi<3
              error('File not found or readerror.');
            else
              fprintf(fi,'%6.2f\t %6.2f\t %6.8f\t %6.8f\t %6.2f\t %6.2f\t %6.8f\r',temp');
            end
            % close
            fclose(fi);
%%%%%%%%%%fin conversion



disp('On sauve les traces avec localization synaptique dans file.MIA.con.syn.trc')

if deco==1
    disp(' ');
    disp('********* On decoupe les traces en fonction de la localisation (deconnectrace) et calcule les msd')
    nwtrccut=deconnectraceMIA(strFile,msdflag);
else
end
