function batch(file,detectpk,opts,diffconst,cutoffs,maxblink,distmax,minTrace,till,sizepixel,longFIT)

% batch(file,detectpk,opts,diffconst,cutoffs,maxblink,distmax,minTrace,till,sizepixel,longFIT)
% batch les datas en utilisant edfPCS, affectsynapses et extractsyn
%    file: fichier
%   detectpk==1: fit les fichiers par edfPCS
%   distmax: distance maximale de connection des traces en pixels
%   minTrace : durée minimum des traces que l'on conserve
%   opt : options chargées par opt=start
%   diffconst : constante de diffusion ‘max’ typique que vous analysez (px2/tlag)
%   cutoffs : de reconnaissance des molécules uniques : [erreur sur l’intensité, intensité max, durée max des traces], typ :[1/3 1000 100]
%   si msdflag=1, calcule le MSD dans deconnectrace
%   till : temps en ms entre deux images (illumination+tlag)
%   sizepixel=taille des pixels en nm
%       longFIT: nombre de points fittés pour la constante de diff
% les fichiers dic doivent avoir la forme: file-dic.spe


if nargin<1, help batch, return, end

if detectpk==1
    edfPCS(file,diffconst,opts);
else
end
files=sbe(file,0);%%%%%%%%j'ai mis 0 à la place de 1 pour le faire marcher avec file et non file.spe
for k=1:length(files)
   strFile=[files(k).name,'.spe'];
   strDIC=[files(k).name,'-dic.spe'];
   disp(['Fichiers actuels: ', strFile, ' et ', strDIC]);
      if length(dir(strFile))>0		% is there new peakdata?
          connectrace(strFile,maxblink,distmax,minTrace,1,diffconst,cutoffs,opts,1);
          extractPCS(strFile,strDIC,till,sizepixel,longFIT);
      end
  end
end