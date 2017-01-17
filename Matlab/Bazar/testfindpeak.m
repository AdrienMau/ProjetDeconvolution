%test findpeak

figure
img=imdata(105);

%FITOPT ??


opt=startqd;
opt(7)=0.5;
opt(9)=1;
result=findpeak(img,opt);
% result: [X0,Y0,W,I,O,dX0,dY0,dW,dI,dO,chi,test]
sr=size(result);
npeaks=sr(1)

s=size(img)
fitg=zeros(s(1),s(2));

%Reconstitution image:
%(utiliser gaussian plutot:)
for(g=1:npeaks)
    variance=result(g,3)*0.4247; %% car FWHM=2 sqrt(2*ln(2)) * sigma
    fitg=fitg+gauss2D(s,[result(g,5),result(g,4),result(g,2),result(g,1),variance]);
end

subplot(211)
imshow2(img)
subplot(212)
imshow2(fitg)

