%test du fit gaussien : comment qu'il marche ?  => OK
% Ne fit qu'une gaussienne 2D.


%comment utiliser fitopt ?

%On crée image avec gaussienne(s) :
    %parametres:
img=zeros(100,80);
size(img)
x=40;y=30;fwhm=20;area=1; % ?? determine le max...
offset=1;
p=[x,y,fwhm,area*5,offset];
G=gaussian(p,100,80); %100: taille horizontale de l'image, 80:verticale

    %on fait fit:
% p0=p+[15,15,5,5,1]; %param initial proche du bon parametre
p0=p*1.4;
maxloops=10;
[pfit,da,chi] = marqogauss(p0,G,zeros(80,100),[0,0,0,0,maxloops]) %usage de marqogauss


    %on compare:
% pfit-p

subplot(311)
title('gaussienne initiale')
imshow2(G)
subplot(312)
title('gaussienne fit')
imshow2(gaussian(pfit,100,80))

MSQ=sum(sum((gaussian(pfit,100,80)-G).^2))

