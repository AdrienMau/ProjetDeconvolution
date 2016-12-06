function trac=plotdetail(taille,xdebut,ydebut)


[d p t c]=speread('toto.spe');

rgbimage=cat(3,zeros(100,100),d/max(max(d)),zeros(100,100));
imshow(rgbimage);

%figure
d1=d(ydebut:ydebut+taille-1,xdebut:xdebut+taille-1);
%rgbimage=cat(3,zeros(taille,taille),d1/max(max(d1)),zeros(taille,taille));
%imshow(rgbimage);
hold on;

trac=[8.1011918e+001  4.8465884e+001  
  8.1814056e+001  4.8735705e+001 
  8.1037241e+001  4.9525723e+001 
  8.0719632e+001  4.8858168e+001 
  8.1053364e+001  4.9810988e+001 
  7.9805899e+001  4.9352769e+001 
  8.0060261e+001  4.8947008e+001 
  8.0616849e+001  4.9089153e+001 
  8.0011987e+001  4.9941939e+001]
trac2=[  9.0816740e+001  3.2617231e+001
         9.1658961e+001  3.3526909e+001
         9.0745805e+001  3.2123331e+001]
     

plot(trac(:,1),trac(:,2),'r-o')

  