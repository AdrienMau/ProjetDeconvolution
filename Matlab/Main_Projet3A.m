%Essai de filtre de Wiener
clear all; close all;

%Opening the blurred image 
imgTrue = imread('particles.jpg'); imgTrue = imgTrue(1:size(imgTrue,1),1:size(imgTrue,1));
initpsf = ones(9,9); initpsf = initpsf / sum(sum(initpsf));

%choix direct psf
figure
subplot(221)
imagesc(imgTrue); axis image off;colormap gray; colorbar; 
title('image ini')
s=size(imgTrue);
rect = round(getrect());
if(rect(2)+rect(4)>s(1))
    rect(4)=s(1)-rect(2);
end
if(rect(1)+rect(3)>s(2))
    rect(3)=s(2)-rect(1);
end
    initpsf=imgTrue(rect(2):(rect(2)+rect(4)),rect(1):(rect(1)+rect(3)));
smin=min(size(initpsf));
initpsf=initpsf(1:smin,1:smin);
size(initpsf)

img = conv2(double(imgTrue),double(initpsf),'same');

x=[1;-2;1];
regulationfilter = transpose(x)*x;

mu=0.001;
sortie = filtreWiener(img,initpsf,regulationfilter,mu);


subplot(222)
imagesc(img); axis image off;colormap gray; colorbar; 
title('image floue')
subplot(223)
imagesc(sortie); axis image off;colormap gray; colorbar; 