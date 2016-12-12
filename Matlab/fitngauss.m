function [ gaussianRI ] = fitngauss( img,seuil,algo,doplot )

%Fit des gaussiennes présentes sur une image, 
% 1 -utilise un seuil pour détecter des zones et le nombre de gaussiennes.
%    Calcule leurs positions et leurs rayons approx.
% 2- fait un algo:
%       algo=1 Fit directement sur n gaussienne
%       algo=2 Fit de 1 gaussienne sur n zones
%       algo=3 Fit de 1 gaussienne sur n zones avec marqogauss


%Entrées:
%   img: image en nuance de gris/ 2D
%   seuil: seuil pour détecter les zones
%Sortie:
%   gaussiansRI: contains radius and intensity of gaussians.

%Par Mau Adrien;

f_r=1.5; %facteur sur le rayon estimé pour les tailles de zone choisies.

if(doplot)
    figure
    barycentres=contoursp(img,seuil);          %taille 3*n i*j  forme [ j i r ] soit [x y r]
else
    barycentres=contours(img,seuil); 
end
n=length(barycentres);
s=size(img);
    
% fit gaussien
gaussianRI=zeros(n,2);
if(algo==1)
   gaussianRI=fit_ngaussRI(img, barycentres);

elseif(algo>1)    %region par region, avec fit_ngauss (où n=1) ou marqogauss
%     figure
    p=zeros(n,5); %for marqogauss
    maxloops=100; %for marqogauss
    for(i=1:n)
        %fit un par un : on crée des zones entourant chaque gaussienne
        r=barycentres(3,i); %radius
        xmin=ceil(1+max(  (barycentres(1,i)-r*f_r) , 1 ));
        ymin=ceil(1+max(  (barycentres(2,i)-r*f_r) , 1 ));
        xmax=floor(min( (barycentres(1,i)+r*f_r) , s(2) ));
        ymax=floor(min( (barycentres(2,i)+r*f_r) , s(1) ));

        if(algo==2)
        %choix fit:
            %juste variance et intensité:
            gaussianRI(i,:)=fit_ngaussRI(img(ymin:ymax,xmin:xmax) , barycentres(:,i)-[xmin;ymin;0]); %fit juste i et R 
        else
            %OU marqogauss : x y 'rayon', intensité et offset 
            %(forcer  l'offset à 0 ?)
            img2=double(img(ymin:ymax,xmin:xmax));
            
            amp=1.13*barycentres(3,i)*barycentres(3,i)*max(max(img2));
            p0=[barycentres(1,i)-xmin,barycentres(2,i)-ymin,barycentres(3,i) amp 0 ];

                [p,fun]=marqogauss(p0,img2,zeros(ymax-ymin+1,xmax-xmin+1),[0,0,0,0,maxloops]);  %fit tout
                
                %       p(1):       X-position
                %       p(2):       Y-position
                %       p(3):       width (FWHM)
                %       p(4):       area
                %       p(5):       offset
                % AMP=4*log(2)/FWHM^2/pi*area
                % FWHM=2 sqrt(2*ln(2)) * sigma

            p(i,:)= p(1:5)+[xmin,ymin,0,0,0];
            barycentres(:,i)=[p(i,1),p(i,2),p(i,3)/(2*sqrt(2*log(2)))];
            gaussianRI(i,:)=[ p(i,3)/(2*sqrt(2*log(2))) , 4*log(2)/p(i,3)^2/pi*p(i,4) ];

        end
        
        
% %         Feedback:
%         subplot(4,3,i)
%         imshow(img(ymin:ymax,xmin:xmax))
        
    end
    
end


fitg=zeros(s(1),s(2));
%utiliser gaussian plutot:
for(g=1:n)
    fitg=fitg+gauss2D(s,[0,gaussianRI(g,2),barycentres(2,g),barycentres(1,g),gaussianRI(g,1)]);
end

MSQ=sum(sum((fitg-img).^2))

if(doplot)
    subplot(224);    imshow(fitg);
    figure
    histogram(gaussianRI(:,1))
    title('repartition des rayons');
end










end

