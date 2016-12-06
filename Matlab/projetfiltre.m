function projetfiltre(input,sbox,type,sigma,alpha);
%Telecharg&é sur http://www.tsi.enst.fr/pages/enseignement/ressources/beti/filt-geom/prog.html


% applique le filtre inverse, le filtre de Wiener et le fitre geometrique sur une image convolee puis bruitee
% exemple d'appel a la fonction : projetfiltre('./images/lena.tif',4,'carre',0.01,0.5)
%
% input = image d'origine 
%
% sbox = taille du filtre correspondant a la reponse impulsionnelle
%
% type = type de réponse impulsionnelle : {'horizontal', 'vertical', 'carre'}
%
% sigma = variance du bruit additif blanc gaussien de moyenne nulle
%
% alpha = parametre du filtre geometrique
%
% Martin Gaume / Olivier Crave
%
% Chargement des donnees image

if(iscellstr(input))
    f = imread(input); %lit l'image
else
    f=input; %input est déjà une image
end


[m,n,p]=size(f); % Taille de l'image
if (p>1)
    f = rgb2gray(f);
end
f = im2double(f);

% Convolution
box = zeros (m,n);
switch type
    case 'horizontal'
        box(1,1:sbox) = 1;
    case 'vertical'
        box(1:sbox,1) = 1;
    case 'carre'
        box(1:sbox,1:sbox) = 1;
    case 'cercle'
        box = fspecial('disk',sbox);
    case 'gaussian'
        box = fspecial('gaussian',sbox,round(sbox/2));
end
box = box / sum(box(:)); %normalisation
Ff = fft2(f);
Hh = fft2(box,m,n);
Cc = Ff.*Hh;
c = real(ifft2(Cc));

% Calcul du bruit
sigma = sqrt(sigma);
noisy = (c + sigma*randn(size(c)) + 0);
noisy = max(0,min(noisy,1));
noisy=f;
Gg = fft2(noisy);

% Filtre inverse
Ffinv=Gg./([abs(Hh)<1e-1].*1e-1+Hh);
finv=im2uint8(abs(ifft2(Ffinv)));

% Filtre de Wiener
H2=abs(Hh).^2; 
Ffwin=H2.*Gg./([(H2+sigma).*Hh<1e-14].*1e-14+((H2+sigma).*Hh));
fwin=im2uint8(abs(ifft2(Ffwin)));

% Filtre géometrique
Ffgeo=(Ffinv.^alpha).*(Ffwin.^(1-alpha));    
fgeo=im2uint8(abs(ifft2(Ffgeo)));

% Calcul du PSNR
psnr_noise = calculate_psnr(f,noisy);
psnr_inv = calculate_psnr(f,finv);
psnr_win = calculate_psnr(f,fwin);
psnr_geo = calculate_psnr(f,fgeo);

% Affichage
figure(1),
subplot(231),imshow(f),title('Original')
subplot(232),imshow(noisy),title(['Image convolée et bruitée, psnr=' num2str(psnr_noise,'%6.2f')])
subplot(234),imshow(finv),title(['Filtre inverse, psnr=' num2str(psnr_inv,'%6.2f')])
subplot(235),imshow(fwin),title(['Filtre de Wiener, psnr=' num2str(psnr_win,'%6.2f')])
subplot(236),imshow(fgeo),title(['Filtre géometrique, alpha=' num2str(alpha) ', psnr=' num2str(psnr_geo,'%6.2f')])

% Sauvegarde des fichiers
f = imresize(f,0.5);
finv = imresize(finv,0.5);
fwin = imresize(fwin,0.5);
fgeo = imresize(fgeo,0.5);
noisy = imresize(noisy,0.5);
imwrite(f,'image.jpg','jpg');
imwrite(finv,'finv.jpg','jpg');
imwrite(fwin,'fwin.jpg','jpg');
imwrite(fgeo,'fgeo.jpg','jpg');
imwrite(noisy,'noisy.jpg','jpg');

function psnr_value = calculate_psnr(im1,im2)
% Mesure la difference entre deux images
%
%
erreur = im2double(im2) - im1;
psnr_value = 20*log10(1/(sqrt(mean(mean(erreur.^2)))));