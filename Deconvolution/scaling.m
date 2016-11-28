function imgout = scaling(imgin, integer)


imgout = zeros(integer*size(imgin,1),integer*size(imgin,2));

calc=ones(integer,integer);

for i=1:size(imgin,1)
    for j=1:size(imgin,2)
    
        imgout(integer*(i-1)+1:integer*i,integer*(j-1)+1:integer*j)=imgin(i,j)*calc;
        
    end
end


end
