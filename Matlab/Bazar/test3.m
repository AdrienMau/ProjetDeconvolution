
%TEST DE CONTOURS, FIT_NGAUSS RI ET AFFICHAGE sur image de trois
%gaussiennes

G=gauss2D([100,120],[0,8,50,20,5])+gauss2D([100,120],[0,3.1,80,60,20])+gauss2D([100,120],[0,5,20,60,9]);
subplot(221)
imshow(G)


barycentres=contoursp(G,mean(max(G)))
gaussianRI=fit_ngaussRI(G, barycentres)


[fun,n]=size(barycentres);
s=size(G);
fitg=zeros(s(1),s(2));
for(g=1:n)
    gau=gauss2D(s,[0,gaussianRI(g,2),barycentres(2,g),barycentres(1,g),gaussianRI(g,1)]);
    fitg=fitg+gau;
end
figure(1)
subplot(224)
imshow(fitg); 
title('fit');
