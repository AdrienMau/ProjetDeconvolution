function imgout = doublesampling(imgin)

imgout=zeros(2*size(imgin,1),2*size(imgin,2));

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
        
        local=imgin(floor((i+1)/2)-1:floor((i+1)/2)+1,floor((j+1)/2)-1:floor((j+1)/2)+1);
        somme=sum(sum(local));
        imgout(i,j)=(imgin(i2,j2)+imgin(floor((i+1)/2),j2)/2+imgin(i2,floor((j+1)/2))+imgin(floor((i+1)/2),floor((j+1)/2))/4)/somme*imgin(floor((i+1)/2),floor((j+1)/2));
        
    end
end


end