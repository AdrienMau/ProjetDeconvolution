function [opt,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments,fileload]=loadparam
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loadparam
% loads parameter for batch programs of SMT and SPT tracking
%
% input: default parameter file if exists
%        (directory \MATLAB6p5p1\ProcedureLC\kakao\)
% output: all the parameters
%        fileload=0 if nothing is loaded
%
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
% saves everything in default.par
%
%MR-jan05                                    MatLab6p5p1 version!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileload=0;

path=['\MATLAB6p5p1\ProcedureLC\kakao\*.par'];
loadpath=['\MATLAB6p5p1\ProcedureLC\kakao\'];
default= ['\MATLAB6p5p1\ProcedureLC\kakao\default.par'];

%choose and load parameters file

if length(dir(default))>0  % if deafults exists, loads default
    fileparam=default;
    fileload=1;
else
  if length(dir(path))>0   %otherwise it will ask for another one
    fileload=1;
  else                       %no previous file                
    qstring=['No parameters files found! Create a new one?'];
    button = questdlg(qstring); 
    if strcmp(button,'Yes')
       [fileload]=paramdefault;
       fileparam=default;
    else 
      disp ('Bye bye! The program will crash now');
      return
    end 
  end
end


if fileload==1
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

  %parameters window
   prompt = {'Peak detection options ("start" files)','Initial diffusion constant (px/frames)','Cutoffs: Intensity error', 'Cutoffs: Maximun intensity','Cutoffs:  Maximun trajectory points','Illumination time (ms)', 'Pixel size (nm)','Max allowed blinking (frames)', 'Max distance (px)', 'Min trace (frames)','Initialize? (0:no 1:yes)', 'Deconnect? (0:no 1:yes)','Points to fit (frames)','Comments'};
   dlg_title = 'Parameters';
   def = {opt,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments};      
   num_lines (:,1) =1;
   num_lines (:,2) =40;
   answer  = inputdlg(prompt,dlg_title,num_lines,def);
   exit=size(answer);
   if exit(1) == 0;
       disp ('Bye bye');
       fileload=0;
       return; 
   end
   
    % reload parameters (string format!!)
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
   
 %save last as default
 
    default= ['\MATLAB6p5p1\ProcedureLC\kakao\default.par'];
    fi = fopen(default,'w');
    if fi<3
       error('File not found or readerror.');
    end;
    fprintf(fi,'%4s %4s %5s %5s %5s %4s %4s %4s %4s %4s %4s %1s %1s %4s %50s',opt,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments);
    fclose(fi);
    %disp(['File default.par saved'])

 
end %fileload control
    
 %end of file
