function [ R ] = approxR( img , fast)
%Contours: renvoie le rayon moyen de figures présentes sur une image

%Idee: seuil d'Otsu, puis détections de zones, Somme sur ces zones des
%pixels blancs: on approxime un cercle dont la somme de ses pixels est alors fonction du rayon.


%Entrées:
%   img: image en nuance de gris/ 2D
%   fast: calcule la moyenne que sur les fast premier rayons (sinon moins)
%Sortie:
%   R : valeur moyenne des rayons

%Par Mau Adrien;


%%
%Chargement

imbin = img<graythresh(img); %image binarisee avec le seuil par la regle d'otsu

%%
%traitement preliminaire
se = strel('disk',1); %seuil pour fermeture
imop=imclose(imbin,se); %fermeture
%%
%compte

[L,num]=bwlabel(1-imop,4); %le deuxieme arg definit le voisinage


if (~exist('fast','var'))
   fast=num;
end

%Selection des labels et reperage centres...
barycentres=zeros(3,num);

%pour chaque forme, ou pour les fast premieres formes:

for lab=1:round(min(fast,num))
    temp=(L==lab);
    [y,x]=find(temp);
    barycentres(1,lab)=mean(x);
    barycentres(2,lab)=mean(y);
    x=x-barycentres(1,lab);
    y=y-barycentres(2,lab);
	barycentres(3,lab)=(sum(sqrt(x.*x+y.*y))*3/(2*pi))^(1/3); %rayon (sum = integrale de r^2 dr dtheta)
end
R=mean(barycentres(3,:));


end

