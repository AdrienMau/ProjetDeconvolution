function [  ] = imshow2(I)
%Imshow2 : affiche une image entre son maximum et son minimum
%   Entrees:
%       I: matrice image de r�ells

imshow(I,'DisplayRange',[min(I(:)) max(I(:))],'InitialMagnification','fit');

end

