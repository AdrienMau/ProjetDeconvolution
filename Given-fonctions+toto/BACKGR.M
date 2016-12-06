%background fitting

file='popctmr3.100';
[data,par]=pmisread(file);
nx=par(1)/par(3);ny=par(2)/par(4)


ix=7;
iy=1;

image=data((iy-1)*ny+1:iy*ny-1,(ix-1)*nx+1:ix*nx-1);
[ysize,xsize] = size(image);


%calculate the intensity profile (background)
[Ytest,Xtest] = find (image==max(max(image)));
aback(1) = xsize /2;
aback(2) = ysize / 2;
aback(3) = (xsize+ysize) / 2;
aback(5) = min(min(image));
aback(4) = mean(mean(image)) - aback(5);
aback = marquard ('gaussian',aback,image);

mesh(gaussian(aback,xsize,ysize))
fwhm=aback(3)
  title('Background')

