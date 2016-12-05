close all
clear all

[d,p,t,c,p2] = trackread('toto107.dat');

[r,x,y,phi]=calcR(d);
r=(r-min(min(r)))/(max(max(r))-min(min(r)));
imshow(r)


%figure 
%imshow(d,[])
[x,y] = ginput(2);

d=r(y(1):y(2),x(1):x(2));
%d=imresize(d,2);
d=doublesampling(d);
d=(d-min(min(d)))/(max(max(d))-min(min(d)));
% d=imread('toto110.bmp');
% d = double(rgb2gray(d));
% d=(d-min(min(d)))/(max(max(d))-min(min(d)));

figure 
imshow(d,[])

%barycentre = contours(d,0.3);
%list = fit_ngaussRI(d,barycentre);
%opt=start;
%bla=findpeak(d,opt);

%%
for n=1:1:7
    
%psf = besselj2D(n);

x = -n:n; x=exp(-x.*x/n);
psf=transpose(x)*x;
figure

%psf2=scaling(psf,3);
imshow(psf);

reg = [0.01,0.2,0.01;0.2,4,0.2;0.01,0.2,0.01];
%reg = [1,-2,1;-2,4,-2;1,-2,1];
%Le filtre du master se defend quand meme
img = filtreWiener(d,psf,reg,0.05);
psf2 = filtreWiener(psf,psf,reg,0.05);
%reg = [0,0,0;0,1,0;0,0,0];
%img = filtreWiener(img,psf2,reg,0.05);
img = img/max(max(img));


%figure
%subplot(211)
%imshow(reg)
%subplot(212)
%imshow(psf)

%psf2 = doublesampling(psf);
%Les filtres donctionnent plus ou moins tous avec une psf en besselJ

%Wiener fonctionne pas trop mal 
%img = deconvwnr(d,psf,0.1);
%psf = deconvwnr(psf,psf,0.1);
%img = deconvwnr(img,psf,0.1);

%Deconvlucy est plutôt rudement efficace
%img = deconvlucy(d,psf);
%psf = deconvlucy(psf,psf);
%img = deconvlucy(img,psf);
%img = img/max(max(img));

%Deconvreg fait apparaitre un certain nombre d'artefact à première vue, à
%voir en bidouilant les paramètres
% for mu=1:0.1:5
%img = deconvreg(d,psf,0.1);
% figure
% imshow(img)
% end

%bof
%img = deconvblind(d,psf,100);

%filtre = img>0.2;
%img = img.*filtre;
img=(img-mean(mean(img)))/(max(max(img))-mean(mean(img)));
figure
imshow(img)
%figure
%histogram(img,1000)
end