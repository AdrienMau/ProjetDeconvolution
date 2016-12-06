function batchSynMIA(file,deco,msdflag,maxblink,distmax,minTrace,till,sizepixel,longFIT)

% batchSynMIA(file,deco,msdflag,maxblink,distmax,minTrace,till,sizepixel,longFIT)
% batch les datas en utilisant , affectsynapsesMIA et extractsynMIA
%       file: fichier (sans extension)
%       maxblink: blinking max autorisé lors de la reconnection (en images)
%       distmax: distance maximale de connection des traces en pixels
%       minTrace : durée minimum des traces que l'on conserve
%       si deco==1 appelle deconnectraceMIA qui crée des traces (.deco.) en fonction de leurs localisation et les sauve dans trc/cut... et msd/cut...
%       si msdflag=1, calcule le MSD dans deconnectrace
%       till : temps en ms entre deux images (illumination+tlag)
%       sizepixel=taille des pixels en nm
%       longFIT: nombre de points fittés pour la constante de diff
%       instantannée
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% il faut que:
%       fichier de synapse: file-loc_MIA.spe
%       fichier de dic: file-dic.spe


if nargin<1, help batchSynMIA, return, end

files=sbe(file,0);%%%%%%%%j'ai mis 0 à la place de 1 pour le faire marcher avec file et non file.spe
for k=1:length(files)
   filesansspe=[files(k).name];
   strFile=[files(k).name,'.spe'];
   strSyn=[files(k).name,'-loc_MIA.spe'];
   strDIC=[files(k).name,'-dic.spe'];
   disp(['Fichiers actuels: ', strFile, ' et ', strSyn]);
      if length(dir(strFile))>0		% is there new peakdata?
          affectsynapsesMIA(filesansspe,strSyn,maxblink,distmax,minTrace,deco,msdflag);
          extractsynPCSMIA(strFile,strSyn,strDIC,till,sizepixel,longFIT);
      end
  end
end

