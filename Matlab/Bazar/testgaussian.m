
%test de gaussian et gauss2D (les deux crée une gaussienne en deux
%dimensions)
%Gaussian est bien plus rapide ! (x10) mais: on ne précise pas directement
%l'amplitude et la variance, on y revient avec:
% AMP=4*log(2)/p(3)^2/pi*p(4)
% FWHM=2 sqrt(2*ln(2)) * sigma


%parametres:
img=zeros(100,80);
x=40;
y=30;
fwhm=4;
area=1; % ?? determine le max...
offset=1;
p=[x,y,fwhm,area*5,offset];
p2=[offset,4*log(2)/p(3)^2/pi*p(4),y,x,fwhm/(2*sqrt(2*log(2)))];
% max(max(G))
% MAX=4*log(2)/p(3)^2/pi*p(4)+offset   %max de la gaussienne, p(4) ='area'
% FWHM=2 sqrt(2*ln(2)) * sigma

G=gaussian(p,100,80); %100: taille horizontale de l'image, 80:verticale
G2=gauss2D([80,100],p2); %G2=G



% 
tic
for(n=1:300)
    G=gaussian(p,100,80);
end
toc
tic
for(n=1:300)
    G2=gauss2D([80,100],p2);
end
toc


