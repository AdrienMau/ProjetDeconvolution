function imgout = doublesampling(imgin)

%Création d'une image plus grande, pour éviter de coder le calcul des bords
imgplus=zeros(size(imgin,1)+2,size(imgin,2)+2);

imgplus(2:size(imgplus,1)-1,2:size(imgplus,2)-1)=imgin;

imgplus(1,2:size(imgplus,2)-1)=imgin(1,:);
imgplus(size(imgplus,1),2:size(imgplus,2)-1)=imgin(size(imgin,1),:);
imgplus(:,1)=imgplus(:,2);
imgplus(:,size(imgplus,2))=imgplus(:,size(imgplus,2)-1);

imgout=zeros(2*size(imgplus,1),2*size(imgplus,2));

for i=3:size(imgout,1)-2
    for j=3:size(imgout,2)-2
    
        if mod(i,2)==0
            i2=floor((i+1)/2)+1;
        else
            i2=floor((i+1)/2)-1;
        end
        if mod(j,2)==0
            j2=floor((j+1)/2)+1;
        else
            j2=floor((j+1)/2)-1;
        end
        
        local=imgplus(floor((i+1)/2)-1:floor((i+1)/2)+1,floor((j+1)/2)-1:floor((j+1)/2)+1);
        somme = sum(sum(local));
         
        %Une formule qui cherche à estimer la portion de lumière du pixel
        %de l'image de départ qui correspond au pixel d'arrivée, version
        %"carré étendu"
        imgout(i,j)=(imgplus(i2,j2)+imgplus(floor((i+1)/2),j2)/2+imgplus(i2,floor((j+1)/2))+imgplus(floor((i+1)/2),floor((j+1)/2))/4)/somme*imgplus(floor((i+1)/2),floor((j+1)/2));
         
        %Une formule qui cherche à estimer la portion de lumière du pixel
        %de l'image de départ qui correspond au pixel d'arrivée,version
        %"carré restreint"
        %rapport = [1/2 1 1/2];
        %rapport = transpose(rapport)*rapport;
        %local2 = rapport.*local;
        %somme2 = sum(sum(local2));
        %imgout(i,j)=(imgin(i2,j2)/4+imgin(floor((i+1)/2),j2)/4+imgin(i2,floor((j+1)/2))/4+imgin(floor((i+1)/2),floor((j+1)/2))/4)/somme2*imgin(floor((i+1)/2),floor((j+1)/2));

         
        %Une formule qui fait une moyenne sur le schéma "carré étendu"
        %imgout(i,j) = (imgin(i2,j2)/4+imgin(floor((i+1)/2),j2)/2+imgin(i2,floor((j+1)/2))+imgin(floor((i+1)/2),floor((j+1)/2)))/9;
    end
end

imgout = imgout(3:size(imgout,1)-2,3:size(imgout,2)-2); 


end