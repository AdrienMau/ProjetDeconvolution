function [fileload]=paramdefault
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% paramdefault
% creates parameter files for batch programs of SMT and SPT tracking
%
% input: parameter file (.par) if exists
%       default directory \MATLAB6p5p1\ProcedureLC\kakao\
% output: fileload=0 if nothing is loaded
%         fileload=1 if parameters are loaded
% Variables loaded to parameters file:
% opt= option file
% diffconst= diffusion constant
% cutoffs:
%   interr= intensity error
%   maxint= maximum intensity
%   maxtraj= maximum number of points for a trajectory
% till= illumination time
% sizepixel= pixel size
% maxblink= maximum blinking
% distmax= maximum distance
% minTrace= minimum number of point in a trajectory
% init= initialization option
% deco= deconnection option
% longFit= number of point for D calculation
% comments= self expression!
%
% saves everything in the .par file whose name is entered
% (overwrites the previous one if the same name is chosen)
% saves a duplicate file as default.mat
%
% MR-jan05                                    MatLab6p5p1 version!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%help paramdefault
fileload=0;

path=['\MATLAB6p5p1\ProcedureLC\kakao\*.par'];
loadpath=['\MATLAB6p5p1\ProcedureLC\kakao\'];

%choose and load structure file

if length(dir(path))>0
                                            %load existing parameters
   d = dir(path);
   st = {d.name};
   [listafiles,v] = listdlg('PromptString','Select file:','SelectionMode','multiple','ListString',st);
   if v==0    %cancel
     disp ('Nothing new saved!');
     disp ('Bye bye');
     return
   end
   fileparam=[loadpath,st{listafiles}];
   savename=st{listafiles};
   %disp(['Loaded parameters:']);
   [opt,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments] = textread(fileparam,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s');
   opt=opt{1};
   diffconst=diffconst{1};
   interr=interr{1};
   maxint=maxint{1};
   maxtraj=maxtraj{1};
   till=till{1};
   sizepixel=sizepixel{1};
   maxblink=maxblink{1};
   distmax=distmax{1};
   minTrace=minTrace{1};
   init=init{1};
   deco=deco{1};
   longFit=longFit{1};
   comments=comments{1};
   fileload=1; 
   
 else                                      %no previous file
    savename=('');                        
    %disp(['No files found']);
     opt=('');
     diffconst=('');
   interr=('');
   maxint=('');
   maxtraj=('');
     till=('');
     sizepixel=('');
     maxblink=('');
     distmax=('');
     minTrace=('');
     init=('');
     deco=('');
     longFit=('');
     comments=('');
     
end

    
%parameters window
   prompt = {'Peak detection options ("start" files)','Initial diffusion constant (px/frames)','Cutoffs: Intensity error', 'Cutoffs: Maximun intensity','Cutoffs:  Maximun trajectory points','Illumination time (ms)', 'Pixel size (nm)','Max allowed blinking (frames)', 'Max distance (px)', 'Min trace (frames)','Initialize? (0:no 1:yes)', 'Deconnect? (0:no 1:yes)','Points to fit (frames)','Comments'};
 dlg_title = 'Parameters';
   def = {opt,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments};      
 num_lines (:,1) =1;
 num_lines (:,2) =40;
 answer  = inputdlg(prompt,dlg_title,num_lines,def);
 exit=size(answer);
 if exit(1) == 0;
       disp ('Nothing new saved!');
       disp ('Bye bye');
       return; 
 end
   
 %parameters entered
   opt=answer{1};
   diffconst=(answer{2});
   interr=answer{3};
   maxint=answer{4};
   maxtraj=answer{5};
   till=(answer{6});
   sizepixel=(answer{7});
   maxblink=(answer{8});
   distmax=(answer{9});
   minTrace=(answer{10});
   init=(answer{11});
   deco=(answer{12});
   longFit=(answer{13});
   comments=answer{14};
   fileload=1;
 
 % dialog box  
 qstring=['Save new parameters?'];
 button = questdlg(qstring); 
 if strcmp(button,'Yes')
     saving=1;
 else 
      saving=0;
      disp ('Nothing new saved!');
 end

 %save data: dialog box to enter name of the parameters file to be created
 
 if saving==1;
     
    prompt = {'New parameters'};
    num_lines= 1;
    dlg_title = 'Input file name';
    def = {savename}; % default value
    ans  = inputdlg(prompt,dlg_title,num_lines,def);
    exit=size(ans);
    if exit(1) == 0;
       disp ('Nothing new saved!');
       return; 
    end
    name=ans{1};
    savepath = ['\MATLAB6p5p1\ProcedureLC\kakao\',name,'.par'];
    default= ['\MATLAB6p5p1\ProcedureLC\kakao\default.par'];
    
    % open files for writing in binary format

    fi = fopen(savepath,'w');
    if fi<3
       error('File not found or readerror.');
    end;
    fprintf(fi,'%4s %4s %5s %5s %5s %4s %4s %4s %4s %4s %4s %1s %1s %4s %20s',opt,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments);
    fclose(fi);
    fi = fopen(default,'w');
    if fi<3
       error('File not found or readerror.');
    end;
    fprintf(fi,'%4s %4s %5s %5s %5s %4s %4s %4s %4s %4s %4s %1s %1s %4s %20s',opt,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments);
    fclose(fi);

    disp(['Files ',savepath,' and default.par saved']);


end %loop save
 

%end of file
