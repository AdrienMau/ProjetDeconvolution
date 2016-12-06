function sm=plotsubimagenp(filename,img,xstart,ystart,cmin,cmax)

global BORDER

BORDER=0
FName = filename(1:find(filename=='.')-1)

[d,p,t,c]=speread(filename);
size(d)

h=getsub(1,img,d,p)

sm = []
for i=1:2   for j=1:2
      sm(i,j)=h(i+xstart,j+ystart);
   end
end



figure;

%cmin = min(min(h));
%cmax = max(max(h));


subplot(2,1,1)
surf(h);
caxis([cmin cmax]);
axis off;
shading interp;

subplot(2,1,2)
imagesc(h);
caxis([cmin cmax]);

%cmin = min(min(sm));
%cmax = max(max(sm));

subplot(2,2,1)
surf(sm);
caxis([cmin cmax]);
axis off;
shading interp;

subplot(2,2,2)
imagesc(sm);
caxis([cmin cmax]);
axis equal

figure;
surf(sm);
caxis([cmin cmax])
axis([0 16 0 16 cmin cmax])

axis off;
shading interp;

%DoIt  = ['save ', FName,'.sub',num2str(pol,1),'.',num2str(img,3),'.dat h -ascii']
%eval (DoIt)
%DoIt  = ['save ', FName,'.smallsub',num2str(img,3),'.dat sm -ascii']
%eval (DoIt)

