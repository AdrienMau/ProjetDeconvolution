function [files,date,bytes,dirs]=readdir(directory, followsubdirs,savefile)
% [filenames, datastatistics]=readdir(directory, followsubdirs)
% no help yet, sorry

if nargin<1
   help readdir
end
if nargin<2
   followsubdirs=1;
end
if nargin<3
   savefile=[];
end

files={}; date={}; bytes=[]; dirs=1;
nfiles=0;

f=dir(directory);
if directory(end)~='\'
   directory=[directory,'\'];
end

for i=1:length(f)
   if f(i).isdir==0
      nfiles=nfiles+1;
      files(nfiles)={[directory,f(i).name]};
		date(nfiles)={f(i).date};      
      bytes=[bytes; f(i).bytes];
   else
      if f(i).name(1)~='.' & followsubdirs
         [nf,nd,nb,ndir]=readdir([directory,f(i).name]);
         dirs=dirs+ndir;
         bytes=[bytes;nb];
         for j=1:length(nf)
            nfiles=nfiles+1;
            files(nfiles)=nf(j);
				date(nfiles)=nd(j);      
         end % for j
      end % if not '.' or '..'
   end % if no directory
end % for i

disp([directory,' with ',num2str(nfiles),' files (',num2str(sum(bytes)),' bytes)']);

if ~isempty(savefile)
   handle=fopen(savefile,'w');
   if handle>0
      for i=1:length(files)
         f=lower(char(files(i)));sl=find(f=='\');if isempty(sl), f=['f:\',f]; sl=3; end
         fprintf(handle,'"%s" "%s" %s %8d\n',f(1:sl(end)),f(sl(end)+1:end),char(date(i)),bytes(i));
      end % for
      fclose(handle);
   else
      warning(['Unable to open file ',savefile]);
   end % if handle>0
end % if ~isempty
