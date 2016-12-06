function h=makempg(tot)

clf;
d=speread('film4.spe');
temp=[]
size(d)
for i=1:150
    for j=1:50
        for k=1:50
            temp(j,k,1,i)=d(j+50*(i-1),k)/2;
        end
    end
end
toto=temp;
h=immovie(toto,red);
MPGWRITE(h, red, 'film4')


