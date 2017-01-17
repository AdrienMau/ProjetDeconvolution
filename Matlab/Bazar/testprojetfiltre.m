%test projet filtre
%pas convaincant... mais faut trouver les bons parametres

% img=imdata(110);
% imshow(img)
% figure
% plot(mean(img(60:65,:)))
% projetfiltre(img,3,'carre',30,0);
% imcontrast

% projetfiltre(img,3,'gaussian',50,0.2);


[X Y] = meshgrid(-1:0.1:1,-1:0.1:1);
size(X)
size(Y)
R = sqrt(X.^2+Y.^2);
f = (2*besselj(1,2*pi*R(:))./R(:)).^2;
bessel=reshape(f,size(X));
surf(bessel)