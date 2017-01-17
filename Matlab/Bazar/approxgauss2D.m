function [ p ] = approxgauss2D(data,p0,dim_h,dim_v)
%approxgauss2D: renvoie les coefficients correspondant à l'approximation d'une
%gaussienne avec offset
%de la forme y=A+Bexp((x-D)^2)/(2s*s)

%Entrées:
%   x et y: données à approximer
%   p0: coefficients autours desquels on va chercher la bonne approximation
%       p0(1) -> offset
%       p0(2) -> amplitude
%       p0(3) -> moyenne (horizontale)
%       p0(4) -> moyenne (verticale)
%       p0(5) -> écart-type

%Sortie:
%       p: coefficients de la gaussienne 2D

%%
options = optimoptions('lsqnonlin','Jacobian','on');
p=lsqnonlin(@(p)Rgauss2D(data,p,dim_h,dim_v),p0);

end

