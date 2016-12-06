function [ p ] = fit_gauss2D( img)
%img est l'image d'une gaussienne2D pour laquelle on souhaite obtenir
%les paramètres

%%%%%
%On fait un fit gaussienne avec lsqnonlin
%   p: coefficients autours desquels on va chercher la bonne approximation
%   //SORTIE//
%       p(1) -> offset selon y => A
%       p(2) -> amplitude
%       p(3) -> moyenne (verticale)
%       p(4) -> moyenne (horizontale)
%       p(5) -> ecart-type vertical

% power: puissance de l'hypergaussienne
%%
%Fait appel à lsqnonlin avec construction de jacobienne
%Nécessite : 
%            Rhgauss2D.m
%%

[dim_v,dim_h]=size(img);%nombre de lignes, nombre de colonnes
fline2=zeros(1,dim_v*dim_h);

[Max,Iv]=max(img);%donne la position verticale de chaque maximum
[Max,I_h]=max(Max);%donne la position horizontale du maximum global
I_v = Iv(I_h);
Min=min(min(img));
rec=[0,0];
k=0;

%permet d'estimer grossièrement la largeur de la gaussienne en param
%d'optimisation
for i=1:dim_v
    if img(i,I_h)>(Max+Min)/2 && k==0
        k=1;
        rec(1)=i;
    end
    if img(i)<Max/2 && k==1
        rec(2)=i;
    end
end

%%
%%crée une ligne dim_v*dim_v pour contenir l'image recoupée à chaque fin de
%ligne   
%      dim_h
%   <---------->
%    1234567891<- => 12345678912345678912
% -> 2345678912
%   ...
%pourquoi pas laisser en 2D ?
% Parce que lsqnonlin ne gère pas la 2D étant donné qu'on peut se ramener
% au cas 1D !
%%


for i=1:dim_v
    fline2((i-1)*dim_h+1:i*dim_h)=img(i,:);
end

% p0 = [ Min, Max-Min, I_h, I_v, (rec(2)-I_v)/sqrt(2*log((2*Max)/(Max-Min))) ]
p0 = [ Min, Max-Min, I_h, I_v, (rec(2)-I_v)/(2*sqrt(2)*log(2)^(1/2)) ]
% options = optimoptions('lsqnonlin','Jacobian','off'); %a voir pour hgauss...
    
p=lsqnonlin(@(p)(Rgauss2D(fline2,p,dim_h,dim_v)),p0);

end

