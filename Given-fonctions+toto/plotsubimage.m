function sm=plotsubimage(filename,pol,img,xstart,ystart,scale)


global BORDER

BORDER=0

FName = filename(1:find(filename=='.')-1);

[d,p,t,c]=speread(filename);
size(d)

h=getsub(1,img,pol,d,p);

sm = []
for i=1:100   for j=1:100
      sm(i,j)=h(i+xstart,j+ystart);
   end
end



figure;

subplot(2,1,1)
surf(h);
caxis([0 scale]);
axis off;
shading interp;

subplot(2,1,2)
imagesc(h);
caxis([0 scale]);
axis equal;


subplot(2,2,1)
surf(sm);
caxis([0 scale]);
axis off;
shading interp;

subplot(2,2,2)
imagesc(sm);
caxis([0 scale]);
axis equal

figure;
surf(sm);
axis([0 50 0 50 0 scale])
caxis([0 scale]);
axis off;
shading interp;

g = h';
figure;
surf(g);
caxis([0 scale]);
axis off;
shading interp;


figure;
imagesc(h);
caxis([0 scale]);
axis equal;
axis off;

%DoIt  = ['save ', FName,'.sub',num2str(pol,1),'.',num2str(img,3),'.dat h -ascii']
%eval (DoIt)
%DoIt  = ['save ', FName,'.smallsub',num2str(pol,1),'.',num2str(img,3),'.dat sm -ascii']
%eval (DoIt)

