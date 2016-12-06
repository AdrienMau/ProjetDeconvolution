function converttoMSDturbo(file,cas)

% if cas==1: batch
% if cas==2: batchsyn
% if cas==3: batchMIA
% if cas==1: batchMIAsyn

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if cas==1
filein=['trc\',file,'.spe.con.trc'];
res=load(filein);
filetxt=['trc\',file,'.spe.con.trc'];
fi = fopen(filetxt,'w')
if fi<3
  error('File not found or readerror.');
else
  fprintf(fi,'%6.2f\t %6.2f\t %6.8f\t %6.8f\t %6.8f\r',res');
end
% close
fclose(fi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%