function [ p,gaussianRI ] = fitngauss2( img,seuil,algo,doplot )

% Fit des gaussiennes présentes sur une image, 
% 1 -utilise un seuil pour détecter des zones et le nombre de gaussiennes.
%    Calcule leurs positions et leurs rayons approx.
% 2- fait un algo:
%       algo=1 Fit directement sur n gaussienne
%       algo=2 Fit de 1 gaussienne sur n zones.     Les positions seront
%       assez approximatives car juste trouvees avec les barycentres.
%       algo=3 Fit de 1 gaussienne sur n zones avec marqogauss /on sort alors aussi p
%          algo=4 à implémenter: findpeak

%AJOUTER FINDPEAK



%Entrées:
%   img: image en nuance de gris/ 2D
%   seuil: seuil pour détecter les zones
%Sortie:
%   p: parametres des n gaussiennes
%   gaussiansRI: contains radius and intensity of gaussians. se retrouve
%   avec p
%   barycentres:


%Par Mau Adrien;

f_r=1.5; %facteur sur le rayon estimé pour les tailles de zone choisies.
p=NaN;
if(algo~=4)
   
    if(doplot)
        figure
        barycentres=contoursp(img,seuil);          %taille 3*n i*j  forme [ j i r ] soit [x y r]
    else
        barycentres=contours(img,seuil); 
    end

n=length(barycentres);
gaussianRI=zeros(n,2);
end
s=size(img);
    
% fit gaussien


if(algo==4) %findpeak sur tout
    opt=startqd;
    opt(7)=0.5;
    opt(9)=1;
    p=findpeak(img,opt); %pas de condition initiale
    % result: [X0,Y0,W,I,O,dX0,dY0,dW,dI,dO,chi,test]
    barycentres=[p(:,1),p(:,2),p(:,3)/(2*sqrt(2*log(2)))]; % x y rayon
    barycentres=barycentres';
    gaussianRI=[ p(:,3)/(2*sqrt(2*log(2))) , 4*log(2)./p(:,3).^2/pi.*p(:,4) ];
    n=size(p,1);

elseif(algo==1)
   gaussianRI=fit_ngaussRI(img, barycentres);
   sigmaa=2*sqrt(2*log(2))*gaussianRI(:,1);
   p=[barycentres(1,:);barycentres(2,:);sigmaa';(gaussianRI(:,2).*sigmaa.^2*pi/(4*log(2)))';zeros(1,n)];  
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
            
            sigma=2*sqrt(2*log(2))*gaussianRI(i,1);
            p(i,:)=[barycentres(1,i),barycentres(2,i),sigma,gaussianRI(i,2)*sigma^2*pi/(4*log(2)),0];  
            % ou offset avec min(min(img)) ?
%             p(i,:)=[barycentres(1,i),barycentres(2,i),sigma,gaussianRI(i,2)*sigma^2*pi/(4*log(2)),min(min(img(ymin:ymax,xmin:xmax)))]; 
        elseif(algo==3)
            %OU marqogauss : x y 'rayon', intensité et offset 
            %(forcer  l'offset à 0 ?)
            img2=double(img(ymin:ymax,xmin:xmax));
            
            amp=1.13*barycentres(3,i)*barycentres(3,i)*max(max(img2));
            p0=[barycentres(1,i)-xmin,barycentres(2,i)-ymin,barycentres(3,i) amp 0 ];
            try
                    [p,fun]=marqogauss(p0,img2,zeros(ymax-ymin+1,xmax-xmin+1),[0,0,0,0,maxloops]);  %fit
            catch
                    [p]=marqogauss(p0,img2,zeros(ymax-ymin+1,xmax-xmin+1),[0,0,0,0,maxloops]);  %fit
            end
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
        
    end %fin du for
    

    
end




if(doplot)
    fitg=zeros(s(1),s(2));
    %utiliser gaussian plutot:
    size(gaussianRI)
    size(barycentres)
    for(g=1:n)
        fitg=fitg+gauss2D(s,[0,gaussianRI(g,2),barycentres(2,g),barycentres(1,g),gaussianRI(g,1)]);
    end


    subplot(224);    imshow(fitg);
    figure
    hist(gaussianRI(:,1))
    title('repartition des rayons');
    MSQ=sum(sum((fitg-img).^2))
    
    figure
    hist(gaussianRI(:,2))
    title('repartition des intensités');
    
    
    
    
end










end

