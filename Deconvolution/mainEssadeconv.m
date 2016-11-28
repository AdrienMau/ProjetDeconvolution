close all
clear all

[d,p,t,c,p2] = trackread('toto107.dat');

imshow(d)

[r,x,y,phi]=calcR(d);

d=doublesampling(r);
%d=scaling(r,2);
%d=r;

d=(d-min(min(d)))/(max(max(d))-min(min(d)));



figure 
imshow(d,[])

%barycentre = contours(d,0.3);
%list = fit_ngaussRI(d,barycentre);

%bla=findpeak(d);

%%
for n=1:1:30
    
%psf = besselj2D(n);

x = -n:n; x=exp(-x.*x/n);
psf=transpose(x)*x;
%psf2=scaling(psf,3);

reg = [0.01,-0.2,0.01;-0.2,4,-0.2;0.01,-0.2,0.01];
%reg = [1/sqrt(2),0.5,1/sqrt(2);0.5,1,0.5;1/sqrt(2),0.5,1/sqrt(2)];
%reg = ones(5,5);
%reg = [0,0,0;0,1,0;0,0,0]
%Le filtre du master se defend quand meme
img = filtreWiener(d,psf,reg,0.1);
%psf = filtreWiener(psf,psf,reg,0.1);
%img = filtreWiener(img,psf,reg,3);
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
% img = deconvreg(d,psf,mu);
% figure
% imshow(img)
% end

%bof
%img = deconvblind(d,psf,15);

%filtre = img>0.2;
%img = img.*filtre;
figure
imshow(img)
%figure
%histogram(img,1000)
end