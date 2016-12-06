function  [MSDout, FullMsdOut]= newMSD (Trc,maxCalcMsd)
%----------------------------------------------------------
% MSD.M
%[Msdout,FullMsdOut] = newMSD(Trc,maxCalcMsd)
% maxCalcMsd: nombre max de points pour lesquels le msd est calculé (prend en compte tous les points de la trajectoire)
% calculate the mean-square displacement from the traces 
% given for five points
% input:   Trc - matrix of particle traces as output from
%                mktrace().
%
% output:  Msd - mean-sqare displacement and it's standard
%                deviation for each particle
%lc 050105
%------------------------------------------------------------
if nargin<1, help newMSD, return, end
if nargin<2
    maxCalcMsd=150;
end

MaxPart = max(Trc(:,1));
MSDout  = [];FullMsdOut=[];
%------------------------------------------
%loop through all particles

for Ipart=1:MaxPart
	iTrc = Trc(find(Trc(:,1)==Ipart),2:4);
   
   if (~isempty(iTrc) & length(iTrc)>2)
		Nlag = size(iTrc,1);   % nombre de points de la trajectoire, pas obligatoirement tous equirépartis dans le temps
      	Mlag = iTrc(Nlag,1)-iTrc(1,1); % intervalle de temps maximum
	  	MSD  = 0;
  
  		% MSD from 1 to Nlag-2
       
        %for lag=1:Nlag-2   
   		for lag=1:min(Mlag,maxCalcMsd); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MSD sur les maxCalcMsd-1 ou Nlag-2 premiers intervalles
            u=0;
            MSD=0;
            iTrc;
            for i=1:Nlag
                  for j=1:Nlag-i
                     if (~isempty(iTrc(i,2)) & ~isempty(iTrc(i+j,2))& iTrc(i+j,1)-iTrc(i,1)==lag)
                         temp(i)=(iTrc(i+j,2)-iTrc(i,2)).^2+(iTrc(i+j,3)-iTrc(i,3)).^2;
                         MSD=MSD+temp(i);
                         u=u+1;
                     else
                     end
                 end
             end          
            if u==0
            else
                MSDout=[MSDout;[Ipart,lag,MSD/u,std(temp)/(sqrt(u))]];
                temp=[];
            end
        end
          FullMsdOut=[FullMsdOut;[MSDout]];
    end % if ~isempty
end
