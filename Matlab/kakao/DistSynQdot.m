function [DisttoCentr, DisttoMax, CentredesSyn, MaxdesSyn, DistInterSyn]=DistSynQdot(file,filesynapse,cutoffs)

% function [DisttoCentr, DisttoMax, CentredesSyn, MaxdesSyn]=DistSynQdot(file,filesynapse,cutoffs)
% calcule les distances to centroide ou to maxima locaux entre les
% molécules et les synapses traitées par MIA à partir des fichiers pk. Les
% cutoffs filtrent les pk donnés par edfPCS comme d'hab.
% résultat: les distances en pixels (DisttoCentr et DisttoMax) et les centroides (CentredesSyn) et maximas locaux(maxdesSyn) des
% synapses

if nargin<1, help affectsynapses, return, end


files=sbe(file,1);
savename=[file];
pkdata=[];
maxim=0;

files;

% load les pics et les filtre
for k=1:length(files)
   str=['pk\',files(k).name,'.pk'];
      if length(dir(str))>0		% is there new peakdata?
      Spkdata =load(str);
      SPok=1;
   else
      Spkdata=[];
      SPok=0;
   end
   if SPok>0
      Spkdata(:,1)=Spkdata(:,1)+maxim;		% new imagenumber
   end
   disp(['*  ',num2str(length(Spkdata)),' peaks in file ',files(k).name,sprintf(' (%d/%d)',k,length(files))]);
   pkdata=[pkdata; Spkdata];
   
   if ~isempty(pkdata)
      maxim=max(pkdata(:,1))+20;
   end
end

disp(['Il y a ',num2str(size(pkdata,1)),' pics avant cutoffs.']);
pkdata=clearpk(pkdata,1,3); % vire les peaks dont les largeurs sont en dehors de [1., 4]
pkind = find(pkdata(:,10)<(pkdata(:,5)*cutoffs(1)) & pkdata(:,5)> 0 & pkdata(:,5)< cutoffs(2)) ;
pkdata = pkdata(pkind,:);
disp(['Reste ',num2str(size(pkdata,1)),' pics après cutoffs.']);


Npics=size(pkdata,1);



%dimension des images
disp('Size of synapse file:');
[d p t c]=userdataread(filesynapse);
%%%%%%%%% x et y sont inversés dans synapses par rapport aux résultats de
%%%%%%%%% edf
Xdim=p(1)
Ydim=p(2)/p(4)
clear d, p, t, c;
nwtrccut=[];
maximas=[];
numsynapse=[];

[maximas, numsynapse, img]=synapses(filesynapse);

Nsyn=max(max(numsynapse))

%Recherche de maximas locaux
Nmaxloc=0
MaxdesSyn=[];
for i=1:Xdim
    for j=1:Ydim
        if maximas(j,i)==1
            Nmaxloc=Nmaxloc+1;
            MaxdesSyn=[MaxdesSyn;[numsynapse(j,i),i,j]];
        else
            
        end
    end
end

disp(['on trouve ',Num2str(Nmaxloc), ' maximas à partir de ', Num2str(Nsyn), ' synapses.']);
MaxdesSyn=sortrows(MaxdesSyn);

%distances intersynapses
DistInterSyn=[];
for i=1:Nmaxloc
      DistInterSynTemp=[];
    for j=1:Nmaxloc
        if j==i
        else
            DistInterSynTemp=[DistInterSynTemp;(MaxdesSyn(i,2)-MaxdesSyn(j,2))^2+(MaxdesSyn(i,3)-MaxdesSyn(j,3))^2];
        end
    end 
DistInterSyn=[DistInterSyn;[i,(min(DistInterSynTemp))^(0.5)]]; 
end

% recherche des centroides de synapses
CentredesSyn=[];
for k=1:Nsyn
    Syntemp=[];
    for i=1:Xdim
        for j=1:Ydim
            if numsynapse(j,i)==k 
                Syntemp=[Syntemp;[i,j]];
            else
            end
        end
    end
sSyntemp=size(Syntemp);
    if sSyntemp(1)==1
        CentredesSyn=[CentredesSyn;[k,Syntemp]];     
    else
        CentredesSyn=[CentredesSyn;[k,mean(Syntemp)]]; 
    end
end

% pic to maximas distances
DisttoMax=[];
max(pkdata(:,2))
max(pkdata(:,3))
for i=1:Npics
    distMaxtemp=[];
    for j=1:Nmaxloc
    distMaxtemp=[distMaxtemp;(pkdata(i,2)-MaxdesSyn(j,2))^2+(pkdata(i,3)-MaxdesSyn(j,3))^2];
    end 
DisttoMax=[DisttoMax;[i,(min(distMaxtemp))^(0.5)]];
end

% pic to centroids distances
DisttoCentr=[];
for i=1:Npics
    distCentrtemp=[];
    for j=1:Nsyn
    distCentrtemp=[distCentrtemp;(pkdata(i,2)-CentredesSyn(j,2))^2+(pkdata(i,3)-CentredesSyn(j,3))^2];
    end 
DisttoCentr=[DisttoCentr;[i,(min(distCentrtemp))^(0.5)]];
end


% visualise
figure;
%les nombres
DistanceMax=round(max(max(DisttoMax(:,2))));
HistNmax=histc(DisttoMax(:,2),1:DistanceMax);
HistNcentr=histc(DisttoCentr(:,2),1:DistanceMax);
%plot(HistNmax);
%hold on;
plot(HistNcentr,'g');

%les densités surfacique (u.A.): je divise par distance
for i=1:DistanceMax
    HistDensmax(i)=HistNmax(i)/i;
end

for i=1:DistanceMax
    HistDenscentr(i)=HistNcentr(i)/i;
end
%figure;
%plot(HistDensmax);
%hold on;
%plot(HistDenscentr,'g');

figure;
imshow(numsynapse);
for i=1:Npics
    text(round(pkdata(i,2)),round(pkdata(i,3)),Num2str(i),'Color',[1,0,0],'FontSize',[8]);
end
figure;
hist(DistInterSyn(:,2));
