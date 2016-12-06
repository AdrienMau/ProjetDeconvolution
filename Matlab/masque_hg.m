function [ image_masquee ] = masque_hg( img,c,a,s,offset,k)
% Multiplie l'img par l'hypergaussienne
%
%ENTREES:
% img: image
% dim = size(img)
% a: amplitude
% c: centre de la gaussienne 2d (x,y)
% k: degre de la gaussienne, pair
% s: écart-type
% SORTIES/
% img: hypergaussienne
%%

dim=size(img);

% fid = fopen(name_Z(fpath,Z) ,'r');
% size=fread(fid,[1,2],'*ubit32','ieee-be'); %retourne [x,y]
% imgor=fread(fid,size,'*float64','ieee-be'); % donne la matrice de l'image
i = hgaussp(dim,c,a,s,offset,k);
image_masquee = img.*i;

end

