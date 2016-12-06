function [ imgout ] = passe_hg( img,fradius,power)
%%
% Passe bas ou passe haut:
% Multiplication terme à terme par un masque hypergaussien dans l'espace de
% Fourier
%Entrées:
%   img: image en nuance de gris/ 2D
%   fradius : facteur pour le rayon de l'hypergaussienne (voir calcul du
%   rayon)
% fradius>0 => passe bas (TF * masque)
% fradius<0 => passe haut (TF * 1-masque)
%   power: hypergaussian power
%Sortie:
%   imgout

%Par Mau Adrien;

%Im
%%

%Test de filtres dans Fourier : Passe bas
if(fradius)

    s=size(img);
    timg=fftshift(fft2(img));
    radius=(sum(sum(timg>mean(max(timg))))/pi)^(1/2); % sum(sum) => environ pi r^2
    % The radius characterizes the surface of the image where the value is
    % higher than the mean of the columns maximums.
    HG=hgauss2D(s,[0,1,s(1)/2,s(2)/2,radius*fradius],power); %mask , radius= r * fradius
    if(fradius>0)
        timg=timg.*(HG);    %passe bas
    else
        timg=timg.*(1-HG); % passe haut
    end
    imgout=abs(ifft2(fftshift(timg)));



    
else
    warning('Passe_hg: fradius is nul')
    imgout=img;
end
end