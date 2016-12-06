function resultsD(option)
% resultsD(option)
% compiles fits information regarding localization or not
% makes files 'extra', 'peri', 'synap' if there is synaptic analisis
% or 'total' (otherwise)
% saves names of files in 'resdata.txt'
% option=1: synaptic
% calculates medians of D

if nargin < 1 
   help resultsD
   return
end


firstenter=1;
nroexp=1;
ex = 1;
ps = 1;
sy=1;
control=1;

% dialog box to enter name of the directory to be created
 prompt = {'Save results in'};
 num_lines= 1;
dlg_title = 'Input result''s folder name';
def = {''}; % default value
answer  = inputdlg(prompt,dlg_title,num_lines,def);
exit=size(answer);
   if exit(1) == 0;
       disp ('Bye bye');
       return; 
   end
name=answer{1};


while control==1  % continous loop to add more data

    
    
    
% dialog box to enter new data
if firstenter==0
     qstring=['Add more data?'];
     button = questdlg(qstring); 
  if strcmp(button,'Yes')
     control=1;
  else 
     break
  end
else
 control=1;  
end

% ask the path of the data 
if firstenter==1
   start_path=cd;
else
   start_path=directory_name;
end
dialog_title=['Select data folder'];
%directory_name = uigetdir(start_path,dialog_title);
directory_name = 'C:\Documents and Settings\Laurent\Mes documents\Data\David\SingleMolPHIAlexa27janvier2005';
if directory_name==0
    break
end

if option==1
     path=[directory_name,'\msd\cut\fits\']
 else
     path=[directory_name,'\msd\fits\'];
 end

if control==1
    
  %choose data
  d = dir(path);
  st = {d.name};
  [listafiles,v] = listdlg('PromptString','Select files:','SelectionMode','multiple','ListString',st);
  if v==0
     return
  end
 
  if firstenter==1
     mkdir (name) 
     [f,ultimo]=size(listafiles);
     firstenter=0;
  end

for cont=1:ultimo
    file=[path,st{listafiles(cont)}];
    x =load(file);
    disp(['File ' ,file, ' loaded.']);
    analizados{nroexp}=file;
    nroexp=nroexp+1;

 if option==1        
    [synmol, totcolumnas] = size (x);  
    for fila = 1: synmol
      if x(fila,5) == 0
          if x(fila,4)==0
          else
           extra (ex,:) = x (fila, :) ;
           ex=ex+1;
          end
       else
          if x(fila,5) < 0
                 perisyn (ps,:) = x (fila, :);  % archivo indice con molec perisyn
                 ps=ps+1;
             else
                 synaptic (sy,:) = x (fila, :) ; % archivo indice con molec syn
                 sy=sy+1;
          end
       end
    end;
   
   else
    %sin distinguir localizacion
   [mol, totcolumnas] = size (x);  
    for fila = 1: mol
           total (ex,:) = x (fila, :) ;
           ex=ex+1;
    end

 end
end % for cont

end % control


end % while

if option==1
    resextra = [name,'\extra.dat'];
        save(resextra,'extra','-ascii') 
x = load ([name,'\extra.dat']);
     [n,m] = size (x);
     m = median ( x (:,2));

     disp (['Extrasynaptic: Median =', num2str(m)])
     disp (['n =',num2str(n)])
     
    resperi = [name,'\peri.dat'];
        save(resperi,'perisyn','-ascii') 
x = load ([name,'\peri.dat']);
     [n,m] = size (x);
     m = median ( x (:,2));

     disp (['Perisynaptic: Median =', num2str(m)])
     disp (['n =',num2str(n)])
     
    ressynap = [name,'\synap.dat'];
       save(ressynap,'synaptic','-ascii') 
  x = load ([name,'\synap.dat']);
     [n,m] = size (x);
     m = median ( x (:,2));

     disp (['Synaptic: Median =', num2str(m)])
     disp (['n =',num2str(n)])
     
 
    disp('Files saved:')
    disp (resextra)
    disp (resperi)
    disp (ressynap)
    
    
    
else
     res = [name,'\total.dat'];
     save(res,'total','-ascii') 
    x = load ([name,'\total.dat']);
     [n,m] = size (x);
     m = median ( x (:,2));

     disp (['Median =', num2str(m)])
     disp (['n =',num2str(n)])
     

    disp(['File ',res,' saved'])
end

save([name,'\resdata.txt'],'analizados') 
