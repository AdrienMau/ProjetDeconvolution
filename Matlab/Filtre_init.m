function [images]=Filtre_init(im,focus,lambda)
%Applique les filtres de base pour améliorer les images:
% -multiplication hgaussp
% -centrage
% -Wiener par la calibration





imcal=imdata('c',focus);
im=masque_rephase(im);
if ~(exist('lambda','var'))
    lambda=minEQM2(imcal,im,r)  %r ?
end
im=abs(FiltreWiener(imcal,im,lambda));
im=imcal-im;
im=removegauss(im)








end



