function [ R ] = RngaussRI(data,p,x,y,barycentres)
%%Calcule la différence entre les données Data et un fit utilisé avec le
%%parametre p.
%utilisé pour lsqnonlin


%data est de taille (1,dim_h*dim_v)
%R est de taille (1,dim_h*dim_v)
%%
%x et y sont formés à partir de la taille initiale de l'image, ils sont le
%lien entre les données data en 1D et l'image initiale 2D /
            % x=zeros(1,dim_v*dim_h);
            % y=x;
            % for i=0:dim_v-1
            %     for j=1:dim_h
            %         x(1,i*dim_h+j)=i+1;
            %         y(1,i*dim_h+j)=j;
            %     end
            % end

%%
%x vaut 1 sur les dim_h premières cases, 2 entre dim_h+1 et 2*dim_h...
%y vaut 1 jusqu'à dim_h sur les dim_h premières cases puis repart à 1 etc..
%%

% e=exp(-(( x-p0(3)).^2+(y-p0(4)).^2)/(2*p0(5)^2));
% J=zeros(dim_v*dim_h,5);
% for i=1:5
%     J(:,i)=jaco_der(i,p0(1),p0(2),p0(3),p0(4),p0(5),x,y,e);
% end

[fun,n]=size(barycentres);
fitg=zeros(1,length(x));
for(g=1:n)
    gau=p(n+g)*exp(-(1/(sqrt(2)*p(g)).^2) *( ((x-barycentres(2,g)).^2) + ((y-barycentres(1,g)).^2)) );
    fitg=fitg+gau;
end

%VERIFICATION
% test=unique(x);dim_v=test(end);dim_h=length(x)/dim_v;
% img=reshape(fitg,dim_h,dim_v);
% figure;subplot(211);imshow(img');
% subplot(212);imshow(reshape(data,dim_h,dim_v)');

 R=data-fitg;
 %  MSQ=sum(sum(R.*R))
 
end