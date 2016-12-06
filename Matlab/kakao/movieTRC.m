function movieTRC(speed,last,option)
% movieTRC(speed,last,option)
% speed: fps 
% last: last frame for the new movie
% option=0: movie  option=1: DIC  option=2: SYN
% shows molecule number, and in white, number of frames at the moment for
% each molecule

if nargin < 1  
   help movieTRC
   return
end

if nargin < 3  
   option=0;
end

% loads and reads .spe file 
[file,path] = uigetfile('*.spe','Load movie');
filename = [path,file];
if filename==0
    return
end

[datamatrix p t c]= userdataread (filename);

% loads traces file 
[trcf,tpath] = uigetfile('*.trc','Load trc file'); 
trcfile = [tpath,trcf];
if trcfile==0
    return
end


x =load(trcfile);
disp(['File ' ,trcfile, ' loaded.']);

[totfilas, c] = size (x);

% options to use DIC or SYN images
 if option == 1
     [filed,path] = uigetfile('*.spe','Load DIC image');
     filename2 = [path,filed];
     [datamatrix2 p t c]= userdataread (filename2);
     if filename2==0
        return
     end
end

 if option == 2
     [files,path] = uigetfile('*.spe','Load SYN image');
     filename2 = [path,files];
     [datamatrix2 p t c]= userdataread (filename2);
     if filename2==0
        return
     end
 end

% load savename
[name] = uiputfile('*.avi','Save movie as ');
if name==0
    saveflag=0;
else
    saveflag=1;
end


%general variables
Xdim=p(1);
Ydim=p(2)/p(4);
nfram=p(4);
clear p, t, c;
ini=1;
posx=1;
fin=Ydim;
framematrix=[];

if nargin==1
    last=nfram;
end

% general loop through frames

for actualframe=1:last
    
    % loads frame from datamatrix
    if option == 0
      for col=ini:fin
        framematrix(posx,:)=datamatrix(col,:);  % movie
        posx=posx+1;
      end
      ini=ini+Ydim;
      fin=fin+Ydim;
      posx=1;
    else
      framematrix(:,:)=datamatrix2(:,:);    % DIC o SYN
    end
    
   % imagen
   framematrix=framematrix-min(min(framematrix));
   framematrix=abs(framematrix/max(max(framematrix)));
   rgbimag=cat(3,zeros(Ydim,Xdim),framematrix,zeros(Ydim,Xdim)); 
   imshow(rgbimag,'notruesize');
   hold on
   
   % for each frame, makes an array with traces of the molecules
   % and plots them
   actualtraces=[];
   control = 0;
   j=1;
   mol=1; % always starts at frame=1 with molecule 1
   flag=0;
               
    for fil=1:totfilas        % loop through all the rows of the trc file
        if fil==totfilas
            mol=mol-1;        %otherwise it does not plot the last one
        end
       if x(fil,1) > mol      % if the molecule number changed, the array of traces is finished
           % plot
           if control > 0
              axis([-10 Xdim+10 -10 Ydim+10]);
              % plots all the previous ones
              %if flag==1
                  %plot(actualtraces(:,3),actualtraces(:,4),'b-'); 
              %end
              if flag < 0 % blinking
                  plot(actualtraces(:,3),actualtraces(:,4),'b-'); 
                  text(actualtraces(j-1,3),actualtraces(j-1,4),sprintf('%0.0f',actualtraces(j-1,1)),'Color',[1 1 0]);
                  text(actualtraces(j-1,3)+2,actualtraces(j-1,4)+2,sprintf('%0.0f',(j-1)),'Color',[1 1 1],'FontSize',8); 
              end
              if flag == 0 
                  plot(actualtraces(:,3),actualtraces(:,4),'r-');
                  text(actualtraces(j-1,3),actualtraces(j-1,4),sprintf('%0.0f',actualtraces(j-1,1)),'Color',[1 1 0]);
                  text(actualtraces(j-1,3)+2,actualtraces(j-1,4)+2,sprintf('%0.0f',(j-1)),'Color',[1 1 1],'FontSize',8);
              end
              resx=Xdim/4;
              resy=Ydim/18;
              text((Xdim-resx),(Ydim-resy),sprintf('Frame : %0.0f',actualframe),'Color',[1 1 1]);
              text ((Xdim/20), resy, sprintf (file),'Color',[1 1 1]);
              hold on
           end
           actualtraces=[];
           control = 0;
           j=1;
           mol=x(fil,1);
       end
       if x(fil,2) < actualframe + 1                % adds the next point
               actualtraces(j,:)=x(fil,:);
               flag=1;                              % flag=1: takes into account all the molecules
               if x(fil,2)==actualframe
                   flag=0;                          % flag=0: molecule present at actual frame
               else
                   if fil<totfilas
                      if x(fil+1,1)==x(fil,1)
                         flag=-1;                   % flag=-1: blinking (present in the next row)
                      end                           
                  end
               end
               control = 1;                           % each time it can add a new point
               j=j+1;
       end
       if control==0    % if it could not add a point, there are no more molecules for that frame: go for the next frame, don't loose time
               fil=totfilas;
       end
    end
    hold off
    peli(actualframe)=getframe(gca);  % gets the figure for the movie
    
%end of general loop 
end

% avi file
%fig=figure;
%set(fig,'DoubleBuffer','on');
if saveflag==1
   set(gca,'xlim',[0 500],'ylim',[0 500],'NextPlot','replace','Visible','off')
   mov = avifile(name,'compression','none','fps',speed,'quality',100)
   mov = addframe(mov,peli);
   mov = close(mov);
end

%play movie
%movie(peli,1,speed);
close all

%end of file