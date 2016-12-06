function [ img ] = imdata(numero)
%imdata :renvoie l'image toto"numero".dat

%Createur: Adrien Mau
%ENTREES:
% numero: 

% SORTIES/
% img: image qui etait contenue



%nombre a renseigner pour choix de focus
snum=num2str(numero);
try
    [a,fun]=trackread(strcat('toto',snum,'.dat'));
    img=calcR(a);
catch
    ['Fichier ',strcat('toto',snum,'.dat'),' non trouvé ou non accessible']
end

 
