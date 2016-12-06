function batchMIA(file,msdflag,maxblink,distmax,minTrace,till,sizepixel,longFIT)

% batchMIA(file,msdflag,maxblink,distmax,minTrace,till,sizepixel,longFIT)
% batch les datas en utilisant , affectsynapsesMIA et extractsynMIA
%       file: fichier (sans extension)
%       maxblink: blinking max autorisé lors de la reconnection (en images)
%       distmax: distance maximale de connection des traces en pixels
%       minTrace : durée minimum des traces que l'on conserve
%       si msdflag=1, calcule le MSD dans connectrace et deconnectrace
%       till : temps en ms entre deux images (illumination+tlag)
%       sizepixel=taille des pixels en nm
%       longFIT: nombre de points fittés pour la constante de diff
%       instantannée
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% il faut que:
%       fichier de dic: file-dic.spe


if nargin<1, help batchMIA, return, end

files=sbe(file,0);%%%%%%%%j'ai mis 0 à la place de 1 pour le faire marcher avec file et non file.spe
for k=1:length(files)
   filesansspe=[files(k).name];
   strFile=[files(k).name,'.spe'];
   strDIC=[files(k).name,'-dic.spe'];
   disp(['Fichiers actuels: ', strFile, ' et ', strDIC]);
      if length(dir(strFile))>0	
          connectraceMIA(filesansspe,maxblink,distmax,minTrace,msdflag,1);
          extractPCSMIA(strFile,strDIC,till,sizepixel,longFIT);
      end
  end
end
