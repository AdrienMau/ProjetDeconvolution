function res=edf(filespec, D, opts)
% EvalDataFiles (filespec, D, opts)
%  D and opts are directly forwarded to doseq
%  filespec is expanded if necessary (see sbe)
%
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

   
curdir=cd;

if find(filespec=='[')>0   % there are numbers in ...
	files=sbe(filespec);
else
   
   path=find(actfile=='/' | actfile=='\'); % any path
   if path>0
   	p = actfile(1:path(end)));   			% dir'd kill the path ...
   end
   
   files=dir(filespec);
   
   if path>0
      for i=1:length(files)
         files(i).name = [p,files(i).name];
      end
   end
end

for i=1:length(files)
   actfile=files(i).name; 
   disp(['*** Starting file ',actfile]);
   [d,p,t,c]=speread(actfile);
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
end

res='OK';
cd(curdir);

disp('*** END');