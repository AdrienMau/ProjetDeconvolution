function [nwpkdata,Nsyn,Nperi,Nextra]=affectsynapsesPEAK(file,filesynapse,numextra,cutoffs)

% function [nwpkdata,Nsyn,Nperi,Nextra]=affectsynapsesPEAK(file,filesynapse,numextra,cutoffs)
% calcule le nombre de pics synaptiques à partir des fichiers pk en tenant
% compte des cutoffs
% appelle synapses pour numéroter les synapses
% file: fichier.spe
% filesynapse: fichier_MIA.spe
% numextra est le chiffre correspondant aux extra (typ 100 ou 0)


if nargin<1, help affectsynapsesPEAK, return, end


files=sbe(file,1);
savename=[file];
pkdata=[];
Nextra=0;
Nsyn=0;
Nperi=0;
files;

[d p t c]=userdataread(filesynapse);
Xdim=p(1);
Ydim=p(2)/p(4);
clear d, p, t, c;


for k=1:length(files)
   str=['pk\',files(k).name,'.pk'];
      if length(dir(str))>0		% is there new peakdata?
      Spkdata =load(str);
      else
      Spkdata=[];
      end
   disp(['*  ',num2str(length(Spkdata)),' peaks in file ',files(k).name,sprintf(' (%d/%d)',k,length(files))]);
   pkdata=[pkdata; Spkdata];
end

[maximas, numsynapse, img]=synapses(filesynapse);

Points=size(pkdata(:,1),1);

temp=[];
for i=1:Points
   if (pkdata(i,10)<(pkdata(i,5)*cutoffs(1)) & pkdata(i,5)> 0 & pkdata(i,5)< cutoffs(2) & pkdata(i,4)>1 & pkdata(i,4)<4)
    temp=[temp;[pkdata(i,:),numsynapse(max(min(round(pkdata(i,3)+1),Ydim),1),max(min(round(pkdata(i,2)+1),Xdim),1))]]; % ! x et y sont inversé dans numsynapse par rapport à Trc
   else
   end
end


TempPoints=size(temp(:,1),1);
for i=1:TempPoints
    if temp(i,16)==numextra
            Nextra=Nextra+1;
    else 
        if temp(i,16)>numextra
           Nsyn=Nsyn+1;
        else
           Nperi=Nperi+1;
        end
    end 
end
disp(['On trouve ', Num2str(Nsyn), ' pics dans les synapses, ', Num2str(Nperi), ' peri sur un total de ', Num2str(Nsyn+Nperi+Nextra), '.'])
end
