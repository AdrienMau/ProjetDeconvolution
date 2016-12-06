function [ hgauss ] = gauss2D(size,p)
%cree une gaussienne en fonction du parametre p, et sur une image de
%taille size.
%gauss2D([I,J],[off,A,moyi,moyj,sigma])

% ENTREE:
%     size: taille de l'image finale
%   p: parametre
%       p(1) -> offset selon y => A
%       p(2) -> amplitude
%       p(3) -> moyenne (verticale)
%       p(4) -> moyenne (horizontale)
%       p(5) -> ecart-type vertical


%exemple: img= hgauss2D([120,120],[0,2,60,60,10],10);


hgauss=zeros(size);
for(i=1:size(1))
    for(j=1:size(2))
        hgauss(i,j)=p(1)+p(2)*exp(-(1/(sqrt(2)*p(5)).^2) *( ((i-p(3)).^2) + ((j-p(4)).^2)) );
    end
end


end

