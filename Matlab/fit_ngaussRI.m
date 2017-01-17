function [ gaussianRI ] = fit_ngaussRI(img, barycentres)

% Fonction adaptée au cas d'une image contenant n gaussiennes à fiter, dont
% on connait le nombre n et les positions Et dont on veut trouver le rayon
% et l'intensité (amplitude)
%Functiun adapted for the fit of radius of intensity of gaussians, of
%which we already know the positions and an approximate radius.



%Entrées:
%   img: image containing gaussians, with no offset
%   barycentres: vector with n columns, containing position I J and approximate radius
%Sortie:
%   gaussianRI: contains radius and intensity of gaussians.

%Author: Mau Adrien;

[dim_v,dim_h]=size(img);%nombre de lignes, nombre de colonnes
data=zeros(1,dim_v*dim_h);



[fun,n]=size(barycentres);

%we create 1D datas for use of lsqnonlin
for i=1:dim_v
    data((i-1)*dim_h+1:i*dim_h)=img(i,:);
end
x=data;
y=x;
for i=0:dim_v-1
    for j=1:dim_h
        x(1,i*dim_h+j)=i+1;
        y(1,i*dim_h+j)=j;
    end
end


amp=max(max(img)); %approximate intensity
p0 = [barycentres(3,:),double(amp)*ones(1,n)]; %first try for parameters

p=lsqnonlin(@(p)(RngaussRI(data,p,x,y,barycentres(1:2,:))),p0);
gaussianRI=reshape(p,n,2);

end

