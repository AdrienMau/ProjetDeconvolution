function [ barycentres ] = contoursp( img,s )
%Contours: renvoie les barycentres et les rayons de 'cercles' présents sur
%l'image
%Fonction identique à Contours, qui affiche en plus les images entre chaque
%étape.

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

if(max(max(img))==min(min(img)))
    subplot(221);imshow(img);title('image initiale');
else
    subplot(221);imshow(img);title('image initiale');  %imshow2 eventuellement
end
%%

%traitement preliminaire
se = strel('disk',1); %seuil pour fermeture

% subplot(222);imshow(imbin);title('image binaire');

imop=imclose(imbin,se); %fermeture
subplot(222);imshow(imop);title('image binaire fermee');

%%
%compte

[L,num]=bwlabel(1-imop,4); %le deuxieme arg definit le voisinage

%labellise surface convexes et...
subplot(223);imshow(L)  %normalement chaque objet a sa couleur
title(['n_s_u_r_f_a_c_e_s =', num2str(num)])

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
line(barycentres(1,:),barycentres(2,:),'LineStyle','none','Marker','+','Color',[1 0 0]);

end

