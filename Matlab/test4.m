
%Test de filtres dans Fourier : Passe bas

if (~exist('img','var'))
    img=double(rgb2gray(imread('particles.jpg')));
end
s=size(img);




timg=fftshift(fft2(img));
radius=(sum(sum(timg>mean(max(timg))))/pi)^(1/2); % sum(sum) => environ pi r^2
HG=hgauss2D(s,[0,1,s(1)/2,s(2)/2,radius*1.5],8);
timg=timg.*(HG);
% timg=timg.*(1-HG); % passe haut
imshowf(timg)
imgf=abs(ifft2(fftshift(timg)));


figure
subplot(121);imshow2(img);title('image initiale')
subplot(122);imshow2(imgf);title('image finale')



