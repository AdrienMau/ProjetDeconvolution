function s=savepdf(filename,MaxIntensity)
%----------------------------------------------------------
% savepdf.m
% saves and plot the intensity pdf from a filename.pk file
% the saved file name is filename.pdf.dat
% lc09082000
%-----------------------------------------------------------

A=load(filename);
FName = filename(1:find(filename=='.')-1);


[t,y]=pdf_old(A(:,5),A(:,10),0,MaxIntensity);
s=[t',y'];

DoIt  = ['save ', FName,'.pdf.dat s -ascii']
eval (DoIt)
figure;
plot(t,y);
