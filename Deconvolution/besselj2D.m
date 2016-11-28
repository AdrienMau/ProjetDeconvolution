function psf = besselj2D(siz) 

psf = zeros(2*siz+1);
x = -siz:siz; x=x.*x/siz;

for i=1:siz
    for j=1:siz
        
    dist(i,j)=x(i)+x(j);
    
    if (dist(i,j)==0) 
    psf(i,j)=1;
    else psf(i,j) = besselj(1,sqrt(dist(i,j)))./dist(i,j);
    end
    
    end
end

end
