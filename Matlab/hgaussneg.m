function [ R ] = hgaussneg(p0,dim_h,dim_v,power)
%%Calcule hypergaussienne (a amplitude negative) en deux dimensions en utilisant des vecteurs 1D
%conçu pour être utilisé avec lsqnonlin
%
%data est de taille (1,dim_h*dim_v)
%R est de taille (1,dim_h*dim_v)
%%

x=zeros(1,dim_v*dim_h);
y=x;
for i=0:dim_v-1
    for j=1:dim_h
        x(1,i*dim_h+j)=i;
        y(1,i*dim_h+j)=j;
    end
end
%%
%x vaut 1 sur les dim_h premières cases, 2 entre dim_h+1 et 2*dim_h...
%y vaut 1 jusqu'à dim_h sur les dim_h premières cases puis repart à 1 etc..
%%

 tx=((x-p0(3)).^power)./(sqrt(2)*p0(5))^power;
 ty=((y-p0(4)).^power)./(sqrt(2)*p0(5))^power;
 
 R=p0(1)+p0(2)*exp(-tx-ty);
end