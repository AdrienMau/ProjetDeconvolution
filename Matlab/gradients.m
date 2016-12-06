%%
%Detection contour et comptage

sigma = sqrt(150);
N=3*sigma;
[X,Y]=meshgrid(-N:N);
%%
A=double(imread('coins.png'));
figure;imagesc(A);colormap(gray(256));title('Coins.png');
%%
tic;
H=exp(-(X.^2+Y.^2)/(2*sigma^2));%Canny
Sx=-X/(2*pi*sigma^4).*H;%Canny
%Sx=1/8*[1 0 -1;2 0 -2 ; 1 0 -1]; Sobel
Sy=Sx';
%%
Gx=conv2(A,Sx,'same');
Gy=conv2(A,Sy,'same');
toc
%%

figure,imagesc(Gx);colormap(gray(256));title('Gx');
figure,imagesc(Gy);colormap(gray(256));title('Gy');
mod=sqrt(Gx.^2+Gy.^2);
figure,imagesc(mod);colormap(gray(256));title('Mod(Gx,Gy)');
