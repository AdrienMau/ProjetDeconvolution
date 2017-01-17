function imgf = FiltreWiener(h,img,lambda)
% Rôle de FiltreWiener : applique le filtre de Wiener associe a une
% perturbation a une image l'ayant subie.
%ENTREES : h = perturbation (ici PSF)
%          img : image à  filtrer
%          lambda : parametre du filtre de Wiener
% SORTIE : image filtree
% AUTEURS : C.Balsier & B.Varin

TFWiener=fft2(h)./((abs(fft2(h))).^2+lambda);
imgf=ifft2(fft2(img).*TFWiener);

end

