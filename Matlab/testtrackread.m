
% [a,fun]=trackread('G:/Professionnel/ProjetDiffraction/Matlab/toto110.dat');
% img=calcR(a);
% imshow(img)

% img2=imdata(110);

imshow(img2)

% img2=imresize(img2,2);
% Rmin=1;
% Rmax=20;
% [centersBright, radiiBright] = imfindcircles(img2,[Rmin Rmax],'ObjectPolarity','bright');
% viscircles(centersBright, radiiBright,'Color','b');

% imgf=fftshift(fft2(img2))
% imgf(50:80,50:80)=1
% imshow(ifft2(imgf))