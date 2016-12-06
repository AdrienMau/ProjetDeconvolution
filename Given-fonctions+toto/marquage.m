function result=marquage(mean, maxplot)

%calcule le degré de marquage en fonction du marquage moyen mean et le plotte jusqu'à la valeur maxplot

x=0:0.1:maxplot;
z=0:1:maxplot;
y=[poisspdf(x,mean)]*100;
result=[poisspdf(z,mean)];
%ygam=[weibpdf(x,mean,mean)]*100;
plot(x,y,'-ro');
%hold on;
%plot(x,ygam,'-go')
axis([0,maxplot+1, 0, (max(y)+10)])
text(2,20,['moyenne du marquage : ',num2str(mean)]);
