function varargout = moviemenu(varargin)
% MOVIEMENU M-file for moviemenu.fig
%      MOVIEMENU, by itself, creates a new MOVIEMENU or raises the existing
%      singleton*.
%
%      H = MOVIEMENU returns the handle to a new MOVIEMENU or the handle to
%      the existing singleton*.
%
%      MOVIEMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MOVIEMENU.M with the given input arguments.
%
%      MOVIEMENU('Property','Value',...) creates a new MOVIEMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before moviemenu_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to moviemenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help moviemenu

% Last Modified by GUIDE v2.5 10-Feb-2005 18:08:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @moviemenu_OpeningFcn, ...
                   'gui_OutputFcn',  @moviemenu_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before moviemenu is made visible.
function moviemenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to moviemenu (see VARARGIN)

% Choose default command line output for moviemenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes moviemenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = moviemenu_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

handles.loc= get(handles.speededit2,'value');
handles.iden= get(handles.speededit2,'value');
handles.file=0;
handles.traces=0;
handles.speed=0;
handles.last=0;



guidata(hObject, handles);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% --- Executes during object creation, after setting all properties.
function speededit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speededit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function speededit2_Callback(hObject, eventdata, handles)
% hObject    handle to speededit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speededit2 as text
%        str2double(get(hObject,'String')) returns contents of speededit2 as a double

handles.speed= get(hObject,'string');
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function lastedit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lastedit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function lastedit3_Callback(hObject, eventdata, handles)
% hObject    handle to lastedit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lastedit3 as text
%        str2double(get(hObject,'String')) returns contents of lastedit3 as a double

handles.last= get(hObject,'string');

guidata(hObject, handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in gopushbutton1.
function gopushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to gopushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if handles.file==0
    msgbox('No background file!','Error','error')
    return
end
if handles.traces==0
    msgbox('No traces file!','Error','error')
    return
end
if handles.speed==0
    msgbox('Enter speed!','Error','error')
    return
end
if handles.last==0
    msgbox('Enter last frame!','Error','error')
    return
end

speed=str2num(handles.speed);
last=str2num(handles.last);
filename = (handles.file);
trcfile = (handles.traces);
name=handles.name;
synflag=handles.loc;

if synflag==1
    answer=findstr(trcfile,'deco');
    if isempty(answer)==1
            msgbox('To distinguish localization enter a deconnected traces file','Error','error')
            return
    end
end


[datamatrix p t c]= userdataread (filename);
%general variables
Xdim=p(1);
Ydim=p(2)/p(4);
nfram=p(4);
clear p, t, c;
ini=1;
posx=1;
fin=Ydim;
framematrix=[];

if nfram==1
    option=1;
else
    option=0;
end

x =load(trcfile);
[totfilas, c] = size (x);

if nargin==1
    last=nfram;
end

if option==0
if last > nfram
    last = nfram;
end
end

% general loop through frames

figure;

for actualframe=1:last
    pause(0.1)
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
      framematrix(:,:)=datamatrix(:,:);   % DIC o SYN
    end
    
   % imagen
   framematrix=framematrix-min(min(framematrix));
   framematrix=abs(framematrix/max(max(framematrix)));
   %rgbimag=cat(3,framematrix,framematrix,framematrix); 

   imshow(framematrix,'notruesize');
   hold on
   
   % for each frame, makes an array with traces of the molecules
   % and plots them
   clear actualtraces;
   control = 0;
   j=1;
   mol=1; % always starts at frame=1 with molecule 1
   flag=1;
   codecol=['w'];

               
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
                  %if synflag == 0
                     codecol=['b-'];
                     %end                     
                     plot(actualtraces(:,3),actualtraces(:,4),codecol);
                     if handles.iden==1
                     text(actualtraces(j-1,3),actualtraces(j-1,4),sprintf('%0.0f',actualtraces(j-1,1)),'Color',[1 1 0]);
                     text(actualtraces(j-1,3)+2,actualtraces(j-1,4)+2,sprintf('%0.0f',(j-1)),'Color',[1 1 1],'FontSize',8);
                     end

              elseif flag == 0 
                  if synflag==1
                      if actualtraces(1,6)<0 %peri
                          codecol=['y'];
                      elseif actualtraces(1,6)>0 %syn
                          codecol=['r'];
                      elseif actualtraces(1,6)==0 %extra
                          codecol=['w'];
                      end
                  else
                  codecol=['r-'];
                  end
               
                  plot(actualtraces(:,3),actualtraces(:,4),codecol);
                  if handles.iden==1
                  text(actualtraces(j-1,3),actualtraces(j-1,4),sprintf('%0.0f',actualtraces(j-1,1)),'Color',[1 1 0]);
                  text(actualtraces(j-1,3)+2,actualtraces(j-1,4)+2,sprintf('%0.0f',(j-1)),'Color',[1 1 1],'FontSize',8);
                  end
             end
              resx=Xdim/4;
              resy=Ydim/18;
              text((Xdim/20),(Ydim-resy),sprintf('Frame : %0.0f',actualframe),'Color',[1 1 1]);
              text ((Xdim/20), resy, sprintf (name),'Color',[1 1 1]);
              hold on
           end
           clear actualtraces;
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
                          %if synflag==0
                            flag=-1;       
                            %end       % flag=-1: blinking (present in the next row)
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
    plot(Xdim,Ydim,'.k');  %just no avoid crash!
    hold off
    peli(actualframe)=getframe(gca);  % gets the figure for the movie
        

%end of general loop 
end

%movie(peli,1,speed);


[name] = uiputfile('*.avi','Save movie as ');
if name==0
    saveflag=0;
else
    saveflag=1;
end

if saveflag==1
   set(gca,'xlim',[0 500],'ylim',[0 500],'NextPlot','replace','Visible','off');
   mov = avifile(name,'compression','none','fps',speed,'quality',100)
   mov = addframe(mov,peli);
   mov = close(mov);
end

%pause
close 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in quitpushbutton2.
function quitpushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to quitpushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


close;


% --- Executes on button press in filepushbutton3.
function filepushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to filepushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% loads and reads .spe file 
[file,path] = uigetfile('*.spe','Load movie');
filename = [path,file];
if filename==0
    return
end
set(handles.filetext7,'string',path);
handles.path=get(handles.filetext7,'string');
set(handles.filetext7,'string',filename);
handles.file=get(handles.filetext7,'string');
set(handles.filetext7,'string',file);
handles.name=get(handles.filetext7,'string');

guidata(hObject, handles);


% --- Executes on button press in tracespushbutton4.
function tracespushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to tracespushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% loads traces file 
[trcf,tpath] = uigetfile('*.trc','Load trc file'); 
trcfile = [tpath,trcf];
if trcfile==0
    return
end
set(handles.trctext8,'string',trcfile);
handles.traces=get(handles.trctext8,'string');
set(handles.trctext8,'string',trcf);


guidata(hObject, handles);



% --- Executes on button press in locradiobutton1.
function locradiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to locradiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of locradiobutton1
handles.loc=get(hObject,'Value');
guidata(hObject, handles);



% --- Executes on button press in identifyradiobutton2.
function identifyradiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to identifyradiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of identifyradiobutton2
handles.iden=get(hObject,'Value');
guidata(hObject, handles);


