function res=edf(filespec, D, opts)
% 
%  D and opts are directly forwarded to doseq
%  filespec is expanded if necessary (see sbe)
%   if reduc == 1, reduction de la taille de l'image voir speread et dataread ligne 70 pour la valeur de la réduction
% 050600 V1.0 by GAB

if nargin<1
   help edf
   return;
end

if nargin<3
   opts=fitopt([]);
end
if nargin<2
   D=1;
end

if ~isglobal('MASCHINE')
   global MASCHINE; MASCHINE='PCXX';
   disp('Created global variable MASCHINE and set it to PCXX');
end

if ~isglobal('BORDER')
   global BORDER; BORDER=0;
   disp('Created global variable BORDER and set it to 0');
end

curdir=cd;

if find(filespec=='[')>0   % there are numbers in ...
	files=sbe(filespec,1);
else
   
   path=find(filespec=='/' | filespec=='\'); % any path
   if path>0
   	p = filespec(1:path(end));   			% dir'd kill the path ...
   end
   
   files=dir(filespec);
   
   if path>0 & length(files)>1
      for i=1:length(files)
         files(i).name = [p,files(i).name];
      end
   end
end

for i=1:length(files)
   actfile=files(i).name; 
   if length(dir(actfile))~=0 				% precaution if some files do not exist
	   disp(['*** Starting file ',actfile]);
	    [d,p,t,c]=userdataread(actfile); 
       clear d;
   
	   path=find(actfile=='/' | actfile=='\'); % any path
      
      if path>0
   	   cd(curdir);									% back to starting dir in case of 
   	   												% relative path ... 
   		cd(actfile(1:path(end)));   			% change to new path ...
		   actfile=actfile((path(end)+1):end); % and get filename
	   end
   
   	if length(dir('pk'))==0
   		mkdir('pk'); mkdir('trc'); mkdir('ind'); mkdir('msd');
		   disp('Created directories pk, trc, ind and msd.');
		end
              doseq(actfile,D,p(4),opts);
              %redotrace (actfile, D, [1 5000 p(4)], opts,1,0)%
          end
end

res='OK';
cd(curdir);

disp('*** END');