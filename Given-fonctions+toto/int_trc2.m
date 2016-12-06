% --------------------------------------------------
% int_trc                                          -
% int_trc calculates the intensity for all peaks   -
%         contained in the specified trace files   -
%                                                  -
% syntax: intensity=int_trc(file)                  -
% output: [x-pos,y-pos,intensity,error,trace-number-
%                                                  -
% author: g.j.                                     -
% date:   8.9.98                                   -
% --------------------------------------------------



function int=int_trc(speicher)


int=[];
intm=[];
ueber=0;

% -----------------
% doing file_work -
% -----------------
file_ind=[1,find(speicher==',')+1,length(speicher)+2];
for i=1:length(file_ind)-1
      clear fi
      file=speicher(file_ind(i):file_ind(i+1)-2);
   Doit1=['load trc\',file];
   Doit2=['load pk\',file];
   eval(Doit1);
      file1=file(1:find(file=='.')-1);
      trc=eval(file1);
      trc=trc(:,1:4);
      trc(:,1)=trc(:,1)+ueber;
      ueber=trc(size(trc,1));
   eval(Doit2);
      file1=file(1:find(file=='.')-1);
      pk=eval(file1);  
      for j=1:size(trc,1)
          ind=find(trc(j,2)==pk(:,1) & trc(j,3)==pk(:,2) & trc(j,4)==pk(:,3));
          int=[int;pk(ind,2),pk(ind,3),pk(ind,7),pk(ind,8),trc(j,1)];
      end
end