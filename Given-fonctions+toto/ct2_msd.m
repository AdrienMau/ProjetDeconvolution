function  [Msdout,FullMsdOut] = ct2_msd (Trc)
%----------------------------------------------------------
% MSD.M
%
% calculate the mean-square displacement from the traces 
% given
%
%
% usage:  Msd = msd (Trc)
%
% input:   Trc - matrix of particle traces as output from
%                mktrace().
%
% output:  Msd - mean-sqare displacement and it's standard
%                deviation for each particle
%
%
% date:    8.7.1994
% author:  ts
% version: <01.30> from <941014.0000>
%------------------------------------------------------------
if nargin<1, help msd, return, end

MaxPart = max(Trc(:,1));
Msdout  = [];FullMsdOut=[];
%------------------------------------------
%loop through all particles
for Ipart=1:MaxPart
	iTrc = Trc(find(Trc(:,1)==Ipart),2:4);
   
   if ~isempty(iTrc)
		Nlag = size(iTrc,1);
		Mlag = iTrc(Nlag,1)-iTrc(1,1);
	  	H2  = [];
  
  		% MSD from 1 to Nlag-2
		if Nlag>2
           for lag=1:Nlag-2
           L = iTrc(1+lag:Nlag,1)-iTrc(1:Nlag-lag,1);
   		   H = (iTrc(1:Nlag-lag,2:3)-iTrc(1+lag:Nlag,2:3)).^2;
	   	   H = sum(H');
      		for il=1:length(L)
		        H1 = zeros(1,Mlag);
   		     H1(L(il)) = H(il);
      		  H2 = [H2;H1];
	      	end
			end
		end
      
      %lag = Nlag-1
      
      H  = (iTrc(1,2:3)-iTrc(Nlag,2:3)).^2;
      H2 = [H2;zeros(1,Mlag-1),sum(H)];
      
      diff=size(H2,2)-size(FullMsdOut,2);
      if diff>0 
         FullMsdOut=[FullMsdOut,zeros(size(FullMsdOut,1),diff)];
      end
      if diff<0
         H2=[H2,zeros(size(H2,1),-diff)];
      end
      FullMsdOut=[FullMsdOut;H2];
      
      Lag=[]; Msd=[]; dMsd=[];
		for il=1:Mlag
			noZ  = find(H2(:,il));
         H1   = H2(noZ,il);
         if length(noZ)>0
            Lag  = [Lag,il];
            Msd  = [Msd,mean(H1)];
            if length(noZ)>1
					dMsd = [dMsd,std(H1)/sqrt(length(noZ))];
		      else
      			dMsd = [dMsd,Msd(length(Msd))];
		      end
         end
      end
      %MSD of that trace
		Msdout = [Msdout; Ipart*ones(length(Lag),1),Lag',Msd',dMsd'];
	end % if ~isempty
end % for i=
