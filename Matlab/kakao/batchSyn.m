function batchSyn(file,detectpk,init,opts,diffconst,cutoffs,maxblink,distmax,minTrace,deco,till,sizepixel,longFIT)

% batchSyn(file,detectpk,init,opts,diffconst,cutoffs,maxblink,distmax,minTrace,deco,till,sizepixel,longFIT)
% batch les datas en utilisant edfPCS, affectsynapses et extractsyn
% file: fichier.spe
%   detectpk==1: fit les fichiers par edfPCS
%   distmax: distance maximale de connection des traces en pixels
%   minTrace : durée minimum des traces que l'on conserve
%   init : réinitialise les traces avant des les connecter (utiliser init=1)
%   opts : options chargées par opt=start
%   si deco==1 appelle deconnectrace qui crée des traces (.deco.) en fonction de leurs localisation et les sauve dans trc/cut... et msd/cut...
%   diffconst : constante de diffusion ‘max’ typique que vous analysez (px2/tlag)
%   cutoffs : de reconnaissance des molécules uniques : [erreur sur l’intensité, intensité max, durée max des traces], typ :[1/3 1000 100]
%   till : temps en ms entre deux images (illumination+tlag)
%   sizepixel=taille des pixels en nm
%   saveopt=1 pour tout sauver
%       longFIT: nombre de points fittés pour la constante de diff
% les fichiers synapses doivent avoir la forme: file-loc_MIA.spe
% les fichiers dic doivent avoir la forme: file-dic.spe


if nargin<1, help batchsyn, return, end

if detectpk==1
    edfPCS(file,diffconst,opts);
else
end


files=sbe(file,0);%%%%%%%%j'ai mis 0 à la place de 1 pour le faire marcher avec file et non file.spe
for k=1:length(files)
   strFile=[files(k).name,'.spe'];
   strSyn=[files(k).name,'-loc_MIA.spe'];
   strDIC=[files(k).name,'-dic.spe'];
   disp(['Fichiers actuels: ', strFile, ' et ', strSyn]);
      if length(dir(strFile))>0		% is there new peakdata?
          affectsynapses(strFile,strSyn,maxblink,distmax,minTrace,init,opts,deco,diffconst,cutoffs);
          extractsynPCS(strFile,strSyn,strDIC,till,sizepixel,longFIT);
      end
  end
end