function trackingMT(ProgramName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trackingMT(ProgramName)
%
% Menu for SPT y SMT tracking analysis using MatLab
%
% -  Loads parameters: default.par if exists, otherwise calls 
%    paramdefault.m to create one. 
%    Default.par file is changed each time!!!!!!
%    Run paramdefault.m before tracking.m to change the default
%    parameters reading other file.par or to save a new file. 
%    
% -  Calls the program ProgramName, that can be:
%    batch
%    batchsyn
%    batchMIA
%    batchsynMIA
%
% MR jan 2005 - MatLab6p5p1 version!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin<1
    help trackingMT
    return
end

answer=1;
default= ['\MATLAB6p5p1\ProcedureLC\kakao\default.par'];
error=10;

while answer==1 %loop parameters loading
  
% loads parameters: 
[opts,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments,fileload]=loadparam;
 if fileload==0
     break
 end
 
%convertion from string format
   opts=str2num(opts);
   diffconst=str2num(diffconst);
   interr=str2num(interr);
   maxint=str2num(maxint);
   maxtraj=str2num(maxtraj);
   till=str2num(till);
   sizepixel=str2num(sizepixel);
   maxblink=str2num(maxblink);
   distmax=str2num(distmax);
   minTrace=str2num(minTrace);
   init=str2num(init);
   deco=str2num(deco);
   longFit=str2num(longFit);
   cutoffs(1)=interr;
   cutoffs(2)=maxint;
   cutoffs(3)=maxtraj;
   
   msdflag=1;   %!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% evaluates parameters loaded to check errors:

%options
optionsfile=['\MATLAB6p5p1\ProcedureLC\FnCommunes\',opts,'.m'];
if length(dir(optionsfile))>0 
else
     error=1;
     qstring=['Options file not found in \MATLAB6p5p1\ProcedureLC\FnCommunes\! Load parameters again?'];
    button = questdlg(qstring); 
    if strcmp(button,'Yes')
       answer=1;
   else 
      disp ('Bye bye!');
      break
    end
   
end

% maxblinking, maxtrace, longfit, etc: >0
if till==0 | sizepixel==0 | distmax==0 | minTrace==0 | longFit==0
    error=3;
    qstring=['At least one wrong value! Load parameters again?'];
    button = questdlg(qstring); 
    if strcmp(button,'Yes')
       answer=1;
    else 
      disp ('Bye bye!');
      break
    end 
    
end

% init o deco: solo 0 o 1
if init==0 | init==1 
else
    error=4;
    qstring=['Initialize: 0 or 1. Load parameters again?'];
    button = questdlg(qstring); 
    if strcmp(button,'Yes')
       answer=1;
    else 
      disp ('Bye bye!');
      break
    end 
end

if deco==0 | deco==1
else
    error=5;
    qstring=['Deconnect: 0 or 1.  Load parameters again?'];
    button = questdlg(qstring); 
    if strcmp(button,'Yes')
       answer=1;
    else 
      disp ('Bye bye!');
      break
    end 
end

if error<5
    answer=1;
    error=10;
else
    answer=0;
    error=0;
end

end % loop loading parameters

% call analysis program

if error==0

    %file name
    defaultfilename= ['\MATLAB6p5p1\ProcedureLC\kakao\defaultfilename.txt'];  %shows the previous value, if it exists
    if length(dir(defaultfilename))>0
        [name] = textread(defaultfilename,'%s');
           file=name{1};
           def = {file,'1'};                    % default values
       else
           def = {'','1'};
    end
    prompt = {'Input file name (use [%1%10%] to analise files 1 to 10)','Fit the peaks (edf)? (0:no, 1:yes)'};
    num_lines= 1;
    dlg_title = 'Analysis';
    ans  = inputdlg(prompt,dlg_title,num_lines,def);
    exit=size(ans);
    if exit(1) == 0;
       disp ('bye bye');
       return; 
    end
    file=(ans{1})        
    detectpk=str2num(ans{2})
    

    fi = fopen(defaultfilename,'w');            %saves the name as default for the next time
    if fi<3
       error('File not found or readerror.');
    end;
    fprintf(fi,'%20s',file);
    fclose(fi);
    
switch ProgramName
    case 'batch'
        disp('Doing batch analysis for SMT without looking to localisation')
        batch(file,detectpk,opts,diffconst,cutoffs,maxblink,distmax,minTrace,till,sizepixel,longFit)
        
    case 'batchsyn'
        disp('Doing batch analysis for SMT looking to localisation')
        batchSyn(file,detectpk,init,opts,diffconst,cutoffs,maxblink,distmax,minTrace,deco,till,sizepixel,longFit)

    case 'batchMIA'
        disp('Doing batch analysis for QD without looking to localisation')
        batchMIA(file,msdflag,maxblink,distmax,minTrace,till,sizepixel,longFit)

    case 'batchsynMIA'
        disp('Doing batch analysis for QD looking to localisation')
        batchSynMIA(file,deco,msdflag,maxblink,distmax,minTrace,till,sizepixel,longFit)
        
    otherwise
        disp('Wrong program name')
        return
end
    
end % error control

close all

%end of file
        
    
    

