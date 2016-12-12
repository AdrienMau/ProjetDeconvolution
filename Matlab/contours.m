function [ barycentres ] = contours( img,s )
%Contours: renvoie les barycentres et les rayons de 'cercles' présents sur
%l'image

%Entrées:
%   img: image en nuance de gris/ 2D
%   s : seuil
%Sortie:
%   vecteur: une ligne = barI barJ rayon

%Par Mau Adrien;

%%
%Chargement
if (~exist('img','var'))
    img=rgb2gray(imread('particles.jpg'));
end

if (~exist('s','var'))
   imbin = img<graythresh(img); %seuil par la regle d'otsu
else
   imbin=img<s;
end


% subplot(221);imshow2(img);title('image initiale');
%%
%traitement preliminaire
se = strel('disk',1); %seuil pour fermeture
imop=imclose(imbin,se); %fermeture
%%
%compte

[L,num]=bwlabel(1-imop,4); %le deuxieme arg definit le voisinage

%Selection des labels et reperage centres...
barycentres=zeros(3,num);
for lab=1:num
    temp=(L==lab);
    [y,x]=find(temp);
    barycentres(1,lab)=mean(x);
    barycentres(2,lab)=mean(y);
    x=x-barycentres(1,lab);
    y=y-barycentres(2,lab);
	barycentres(3,lab)=(sum(sqrt(x.*x+y.*y))*3/(2*pi))^(1/3); %rayon (sum = integrale de r^2 dr dtheta)
end

end

