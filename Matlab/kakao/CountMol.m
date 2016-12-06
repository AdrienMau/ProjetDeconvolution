
function [Nsyn,Nperi,Nextra] = CountMol (file,numextra)
% function [Nsyn,Nperi,Nextra] = CountMol (file,,numextra)
% compte les pics trouvés dans les synpases, peri et extra à partir des
% traces non coupées générées par affectsynpases
% numextra est le chiffre correspondant aux extra (typ 100 ou 0)



files=sbe(file,1);
savename=[file];
trcdata=[];
Nextra=0;
Nsyn=0;
Nperi=0;
files;

for k=1:length(files)
   str=['trc\',files(k).name,'.syn.trc'];
      if length(dir(str))>0		% is there new peakdata?
      Strcdata =load(str);
      else
      Strcdata=[];
      end
   disp(['*  ',num2str(length(Strcdata)),' peaks in file ',files(k).name,sprintf(' (%d/%d)',k,length(files))]);
   trcdata=[trcdata; Strcdata];
end

Ntot=size(trcdata,1);
disp(['Il y a ',num2str(Ntot),' pics au total.']);

for i=1:Ntot
    if trcdata(i, 6)==numextra
       Nextra=Nextra+1;
   else 
       if trcdata(i, 6)>numextra
          Nsyn=Nsyn+1;
      else
          Nperi=Nperi+1;
      end
  end
end
disp(['On trouve ', Num2str(Nsyn), ' pics dans les synapses, ', Num2str(Nperi), ' peri sur un total de ', Num2str(Ntot), '.'])

end