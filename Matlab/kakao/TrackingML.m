function varargout = TrackingML(varargin)
% TRACKINGML M-file for TrackingML.fig
%      

% Last Modified by GUIDE v2.5 11-Feb-2005 16:21:01



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrackingML_OpeningFcn, ...
                   'gui_OutputFcn',  @TrackingML_OutputFcn, ...
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function TrackingML_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrackingML wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Outputs from this function are returned to the command line.
function varargout = TrackingML_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure

% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%figure window

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% select program

    function selectpopupmenu2_CreateFcn(hObject, eventdata, handles)
    if ispc
      set(hObject,'BackgroundColor','white');
    else
     set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
    end

function selectpopupmenu2_Callback(selecthObject, eventdata, handles)

handles.selecthObject= get(selecthObject,'Value');
guidata(selecthObject, handles);
set (handles.prog,'value',1);


if handles.selecthObject>1
    
    set (handles.fileedit12, 'Enable','on')  % the program was correctly selected, everything can be loaded
    set (handles.name, 'Enable','on') 
    set (handles.savepushbutton4, 'Enable','on') 
    
    % load default parameters
    if handles.selecthObject<4    %MatLab analysis
                %default= ['\MATLAB7\work\defaultMLT.par'];
       default= ['\MATLAB6p5p1\ProcedureLC\kakao\defaultMLT.par'];
    else
                %default= ['\MATLAB7\work\defaultMIA.par'];
       default= ['\MATLAB6p5p1\ProcedureLC\kakao\defaultMIA.par'];
    end
    
    fileparam=default;
    
    %choose and load parameters file
    if length(dir(default))>0  % if defaults exists, loads default
        set (handles.titulo,'value',1);
    else
       set (handles.titulo,'value',0);
    end
    
    handles.file=get(handles.fileedit12,'String');

if isempty(handles.file)==0
    set (handles.analyzepushbutton1, 'Enable','on')   ; 
else
    set (handles.analyzepushbutton1, 'Enable','off') ;
end
   set (handles.analyzepushbutton1, 'value',1);


    guidata(gcbo,handles) ;
    loadparameters (fileparam,handles)
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%file name

function fileedit12_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function fileedit12_Callback(filehObject, eventdata, handles)

handles.file=get(filehObject,'String');

if isempty(handles.file)==0
    set (handles.analyzepushbutton1, 'Enable','on')    ;
else
    set (handles.analyzepushbutton1, 'Enable','off') ;
end
guidata(filehObject, handles);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%edf

function deteckpeakradiobutton4_Callback(detectpkhObject, eventdata, handles)

handles.detectpk=get(detectpkhObject,'Value');
guidata(detectpkhObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%reads parameters 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pointtofit_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function pointtofit_Callback(hObject, eventdata, handles)

handles.longfit=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function minpoints_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function minpoints_Callback(hObject, eventdata, handles)

handles.mintrace=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function illtime_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function illtime_Callback(hObject, eventdata, handles)

handles.till=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function szpx_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function szpx_Callback(hObject, eventdata, handles)

handles.sizepixel=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function msdflagradiobutton1_Callback(hObject, eventdata, handles)

handles.msdflag=get(hObject,'value');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dconst_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function dconst_Callback(hObject, eventdata, handles)

handles.diffconst=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mblink_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function mblink_Callback(hObject, eventdata, handles)

handles.maxblink=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dmax_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function dmax_Callback(hObject, eventdata, handles)

handles.distmax=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function option9_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function option9_Callback(hObject, eventdata, handles)

handles.opt9=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function decoradiobutton2_Callback(hObject, eventdata, handles)

handles.deco=get(hObject,'value');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cutoff3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function cutoff3_Callback(hObject, eventdata, handles)

handles.maxpoints=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cutoff2_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function cutoff2_Callback(hObject, eventdata, handles)

handles.maxintensity=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cutoff1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function cutoff1_Callback(hObject, eventdata, handles)

handles.intensityerror=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function optpopupmenu1_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function optpopupmenu1_Callback(hObject, eventdata, handles)


d=dir(fullfile(matlabroot,'ProcedureLC/FnCommunes/*start*'));
st = {d.name};
[listafiles,v] = listdlg('PromptString','Select files:','SelectionMode','multiple','ListString',st);
  if v==0
     return
  end
filename=st{listafiles(1)};
[file,rem]=strtok(filename,'.');
set(hObject,'string',file);
handles.options=get(hObject,'String');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function initradiobutton3_Callback(hObject, eventdata, handles)

handles.init=get(hObject,'value');
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%menu


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[file,path] = uigetfile('*.spe','Load file');
filename = [path,file];
if file==0
    return
end

[file,rem]=strtok(file,'.');

handles.file=get(handles.name,'String');
handles.file=file;
set (handles.name, 'Enable','on') ;
set (handles.fileedit12, 'Enable','on') ;

set (handles.fileedit12, 'string',file);
val=get(handles.analyzepushbutton1,'value');
if val>0
   set (handles.analyzepushbutton1, 'Enable','on');
end

guidata(gcbo, handles);

% --------------------------------------------------------------------
function batch_Callback(hObject, eventdata, handles)
% hObject    handle to batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    qstring=['Do you want to quit?'];
    button = questdlg(qstring); 
    if strcmp(button,'Yes')
       close
    end



% --------------------------------------------------------------------
function parameters_Callback(hObject, eventdata, handles)
% hObject    handle to parameters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openpar_Callback(hObject, eventdata, handles)

control=get(handles.prog,'value') ;
if control==1
  
path=['\MATLAB6p5p1\ProcedureLC\kakao\*.par'];
loadpath=['\MATLAB6p5p1\ProcedureLC\kakao\'];


%choose and load structure file
if length(dir(path))>0
                                            %load existing parameters
   d = dir(path);
   st = {d.name};
   [listafiles,v] = listdlg('PromptString','Select file:','SelectionMode','multiple','ListString',st);
   if v==0    %cancel
     return
   else
       fileparam=[loadpath,st{listafiles}];
       savename=st{listafiles};
       set (handles.titulo,'value',1);
       guidata(gcbo,handles) ;
       loadparameters (fileparam,handles)
   end
end
end
% --------------------------------------------------------------------
function editpar_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function peakintensity_Callback(hObject, eventdata, handles)
% hObject    handle to peakintensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure;
histotest(1)
% --------------------------------------------------------------------
function intensitydispersion_Callback(hObject, eventdata, handles)
% hObject    handle to intensitydispersion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure;
histotest(2)


% --------------------------------------------------------------------
function peaksoffset_Callback(hObject, eventdata, handles)
% hObject    handle to peaksoffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure;
histotest(3)

% --------------------------------------------------------------------
function movie_Callback(hObject, eventdata, handles)
% hObject    handle to movie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

moviemenu;

% --------------------------------------------------------------------
function Dcurve_Callback(hObject, eventdata, handles)
% hObject    handle to Dcurve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


control=get(handles.prog,'value') ;
if control==1

% loads and reads .spe file 
[file,path] = uigetfile('*.spe','Load movie');
filename = [path,file];
if filename==0
    return
end

           handles.options=get (handles.optpopupmenu1,'string');
           handles.opt9=get (handles.option9,'string');
           handles.diffconst=get  (handles.dconst,'string');
           handles.intensityerror=get (handles.cutoff1,'string');
           handles.maxintensity=get (handles.cutoff2,'string');
           handles.maxpoints=get (handles.cutoff3,'string');
           handles.maxblink=get (handles.mblink,'string');


           opt=str2num(handles.options);
           opt(9)=str2num(handles.opt9);
           diffconst=str2num(handles.diffconst);
           interr=(handles.intensityerror);
           maxint=(handles.maxintensity);
           maxtraj=(handles.maxpoints);
           cutoffs(1)=str2num(interr);
           cutoffs(2)=str2num(maxint);
           cutoffs(3)=str2num(maxtraj);

%figure
redo6traces(file, diffconst, cutoffs,opt)

end


% --------------------------------------------------------------------
function diffusionconstant_Callback(hObject, eventdata, handles)
% hObject    handle to diffusionconstant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

resultsdif

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function definitions_Callback(hObject, eventdata, handles)
% hObject    handle to definitions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function analysishelp_Callback(hObject, eventdata, handles)
% hObject    handle to analysishelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function version_Callback(hObject, eventdata, handles)
% hObject    handle to version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%quit

function quitpushbutton3_Callback(hObject, eventdata, handles)

    qstring=['Do you want to quit?'];
    button = questdlg(qstring); 
    if strcmp(button,'Yes')
       close
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%extra functions


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function loadparameters (fileparam,handles)

fileload=get(handles.titulo,'value');

if fileload==1
   [opt,opt9,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments] = textread(fileparam,'%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
else
   [opt,opt9,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments]=nodefault(handles);
end
    
% common parameters

  
  set (handles.illtime, 'string',till{1});
  set (handles.szpx, 'string',sizepixel{1});
  set (handles.pointtofit, 'string',longFit{1});
  set (handles.minpoints, 'string',minTrace{1});

 % handles.comments=get (handles.prog,'string')
 % set (handles.comments,'string',comments{1});

switch handles.selecthObject
    case 2
        % MatLab tracking analysis without looking to localisation
           set (handles.optpopupmenu1, 'enable','on','string',opt{1});
           opts=str2num(opt{1});
           set (handles.option9, 'enable','on','string',opt9{1});
           set (handles.dconst, 'enable','on','string',diffconst{1});
           
           %cutoffs
           set (handles.cutoff1,'enable','on', 'string',interr{1});
           set (handles.cutoff2, 'enable','on','string',maxint{1});
           set (handles.cutoff3, 'enable','on','string',maxtraj{1});
           %
           set (handles.mblink, 'string',maxblink{1});
           set (handles.dmax, 'string',distmax{1});
           
           set (handles.initradiobutton3, 'enable', 'off');
           set (handles.decoradiobutton2, 'enable', 'off');
           set (handles.msdflagradiobutton1, 'enable', 'off');
           set (handles.deteckpeakradiobutton4,'enable','on','value',1);

           
           if strcmp(opt{1},'N/A')==1
                 msgbox('Wrong parameters for this analysis!','Parameters','error')
                 set (handles.analyzepushbutton1, 'Enable','off') ;
                 guidata(gcbo,handles) ;
                 return
           end
        
    case 3
        %MatLab tracking analysis looking to localisation
           set (handles.optpopupmenu1,'enable','on', 'string',opt{1});
           opts=str2num(opt{1});
           set (handles.option9, 'enable','on','string',opt9{1});
           
           set (handles.dconst, 'enable','on','string',diffconst{1});
           %cutoffs
           set (handles.cutoff1,'enable','on','string',interr{1});
           set (handles.cutoff2,'enable','on', 'string',maxint{1});
           set (handles.cutoff3,'enable','on', 'string',maxtraj{1});
           
           set (handles.mblink,'enable','on', 'string',maxblink{1});
           set (handles.dmax,'enable','on', 'string',distmax{1});
           
           set (handles.initradiobutton3, 'enable', 'on', 'value',1);
           set (handles.decoradiobutton2, 'enable', 'on', 'value',str2num(deco{1}));
           set (handles.msdflagradiobutton1, 'enable','off');
           set (handles.deteckpeakradiobutton4,'enable','on','value',1);

           if strcmp(opt{1},'N/A')==1
                 msgbox('Wrong parameters for this analysis!','Parameters','error')
                 set (handles.analyzepushbutton1, 'Enable','off') ;
                 guidata(gcbo,handles) ;
                 return
           end


    case 4
        %MIA tracking analysis without looking to localisation
           set (handles.optpopupmenu1, 'enable','off','string','N/A');
           set (handles.option9, 'enable','off','string','N/A');
           set (handles.dconst, 'enable','off','string','N/A');
           %cutoffs
           set (handles.cutoff1, 'enable','off','string','N/A');
           set (handles.cutoff2, 'enable','off','string','N/A');
           set (handles.cutoff3, 'enable','off','string','N/A');

           set (handles.mblink,'enable','on', 'string',maxblink{1});
           set (handles.dmax, 'enable','on','string',distmax{1});
           set (handles.msdflagradiobutton1,'enable','on','value',1);
           
           set (handles.initradiobutton3, 'enable', 'off');
           set (handles.decoradiobutton2, 'enable', 'off');
             set (handles.deteckpeakradiobutton4,'enable','off');



    case 5
        %MIA tracking analysis looking to localisation
           set (handles.optpopupmenu1, 'enable','off','string','N/A');
           set (handles.option9, 'enable','off','string','N/A');
           set (handles.dconst, 'enable','off','string','N/A');
           %cutoffs
           set (handles.cutoff1, 'enable','off','string','N/A');
           set (handles.cutoff2, 'enable','off','string','N/A');
           set (handles.cutoff3, 'enable','off','string','N/A');

           set (handles.mblink, 'enable','on','string',maxblink{1});
           set (handles.dmax,'enable','on', 'string',distmax{1});
           
           set (handles.decoradiobutton2, 'enable', 'on', 'value',str2num(deco{1}));
           set (handles.initradiobutton3, 'enable', 'off');
           set (handles.msdflagradiobutton1, 'enable', 'on','value', 1);
             set (handles.deteckpeakradiobutton4,'enable','off');

    
end

guidata(gcbo,handles) ;

%else
  %  set (handles.fileedit12, 'Enable','off') 
   % set (handles.name, 'Enable','off') 
%end    %fileload control


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function saveparameters(savepath,handles)

   till=num2str(handles.till);
   sizepixel=num2str(handles.sizepixel);
   minTrace=num2str(handles.mintrace);
   longFit=num2str(handles.longfit);
   maxblink=num2str(handles.maxblink);
   distmax=num2str(handles.distmax);
   
   opt=(handles.options);
   opt9=num2str(handles.opt9);
           
   diffconst=num2str(handles.diffconst);
   interr=num2str(handles.intensityerror);
   maxint=num2str(handles.maxintensity);
   maxtraj=num2str(handles.maxpoints);
   init=num2str(handles.init);
   deco=num2str(handles.deco);
   msdflag=num2str(handles.msdflag);
   comments=('');
    
    % open files for writing in binary format

    fi = fopen(savepath,'w');
    if fi<3
       error('File not found or readerror.');
    end;
    fprintf(fi,'%4s %4s %4s %5s %5s %5s %4s %4s %4s %4s %4s %4s %1s %1s %4s %20s',opt,opt9,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments);
    fclose(fi);

    
  msgbox(['File ',savepath,' saved'],'Saving parameters')

  
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function analyzepushbutton1_Callback(hObject, eventdata, handles)

    
%initialize handles


           handles.till=get (handles.illtime,'string');
           handles.sizepixel=get (handles.szpx,'string');
           handles.longfit=get (handles.pointtofit,'string');
           handles.mintrace=get (handles.minpoints,'string');
          
           
           handles.options=get (handles.optpopupmenu1,'string');
           handles.opt9=get (handles.option9,'string');
           handles.diffconst=get  (handles.dconst,'string');
           handles.intensityerror=get (handles.cutoff1,'string');
           handles.maxintensity=get (handles.cutoff2,'string');
           handles.maxpoints=get (handles.cutoff3,'string');
           handles.maxblink=get (handles.mblink,'string');
           handles.distmax=get (handles.dmax,'string');
           
           handles.init=get (handles.initradiobutton3,'value');
           handles.deco=get (handles.decoradiobutton2,'value');
           handles.msdflag=get (handles.msdflagradiobutton1,'value');
           
           handles.file=get(handles.fileedit12,'string');
           handles.detectpk=get(handles.deteckpeakradiobutton4,'value');
    guidata(gcbo,handles) ;
       

%variables definition
   till=str2num(handles.till);
   sizepixel=str2num(handles.sizepixel);
   minTrace=str2num(handles.mintrace);
   longFit=str2num(handles.longfit);
   
   maxblink=str2num(handles.maxblink);
   distmax=str2num(handles.distmax);

   file=(handles.file);

   %comments=comments{1};

%executes analysis


switch handles.selecthObject
    case 2
        disp('Doing MatLab tracking analysis without looking to localisation')
           opt=str2num(handles.options);
           opt(9)=str2num(handles.opt9);
           diffconst=str2num(handles.diffconst);
           interr=(handles.intensityerror);
           maxint=(handles.maxintensity);
           maxtraj=(handles.maxpoints);
           cutoffs(1)=str2num(interr);
           cutoffs(2)=str2num(maxint);
           cutoffs(3)=str2num(maxtraj);
           detectpk=(handles.detectpk);

           set (handles.prog, 'string', 'batch.m running...');
        batch(file,detectpk,opt,diffconst,cutoffs,maxblink,distmax,minTrace,till,sizepixel,longFit);
        
    case 3
        disp('Doing MatLab tracking analysis looking to localisation')
           opt=str2num(handles.options);
           opt(9)=str2num(handles.opt9);
           diffconst=str2num(handles.diffconst);
           interr=(handles.intensityerror);
           maxint=(handles.maxintensity);
           maxtraj=(handles.maxpoints);
           cutoffs(1)=str2num(interr);
           cutoffs(2)=str2num(maxint);
           cutoffs(3)=str2num(maxtraj);
           init=(handles.init)    ;     
           deco=(handles.deco);
           detectpk=(handles.detectpk);

           set (handles.prog, 'string', 'batchSyn.m running...');
           batchSyn(file,detectpk,init,opt,diffconst,cutoffs,maxblink,distmax,minTrace,deco,till,sizepixel,longFit);

    case 4
        disp('Doing MIA tracking analysis without looking to localisation');
        msdflag=(handles.msdflag);
        
           set (handles.prog, 'string', 'batchMIA.m running...');
        batchMIA(file,msdflag,maxblink,distmax,minTrace,till,sizepixel,longFit);

    case 5
        disp('Doing MIA tracking analysis looking to localisation');
        deco=(handles.deco);
        msdflag=(handles.msdflag);

        
        set (handles.prog, 'string', 'batchSynMIA.m running...');
       batchSynMIA(file,deco,msdflag,maxblink,distmax,minTrace,till,sizepixel,longFit);
end

%save default parameters
if handles.selecthObject<4
    default= ['\MATLAB6p5p1\ProcedureLC\kakao\defaultMLT.par'];
        %default= ['\MATLAB7\work\defaultMLT.par'];
else
    default= ['\MATLAB6p5p1\ProcedureLC\kakao\defaultMIA.par'];
        %default= ['\MATLAB7\work\defaultMIA.par'];

end

set (handles.prog, 'string', 'Analysis program');

saveparameters(default,handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [opt,opt9,diffconst,interr,maxint,maxtraj,till,sizepixel,maxblink,distmax,minTrace,init,deco,longFit,comments]=nodefault(handles);

       opt={'start'};
       opt9={'1.9'};
       diffconst={'1'};
       interr={'1/3'};
       maxint={'1000'};
       maxtraj={'100'};
       till={'58'};
       sizepixel={'173'};
       maxblink={'5'};
       distmax={'5'};
       minTrace={'4'};
       longFit={'5'};
       init={'0'};
       deco={'1'};
       comments={''};
       
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in savepushbutton4.
function savepushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to savepushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%save actual parameters values
%fileload=get(handles.titulo,'value')

%if fileload==1

%initialize handles
%initializehandles(handles)


           handles.till=get (handles.illtime,'string');
           handles.sizepixel=get (handles.szpx,'string');
           handles.longfit=get (handles.pointtofit,'string');
           handles.mintrace=get (handles.minpoints,'string');
          
           
           handles.options=get (handles.optpopupmenu1,'string');
           handles.opt9=get (handles.option9,'string');
           handles.diffconst=get  (handles.dconst,'string');
           handles.intensityerror=get (handles.cutoff1,'string');
           handles.maxintensity=get (handles.cutoff2,'string');
           handles.maxpoints=get (handles.cutoff3,'string');
           handles.maxblink=get (handles.mblink,'string');
           handles.distmax=get (handles.dmax,'string');
           
           handles.init=get (handles.initradiobutton3,'value');
           handles.deco=get (handles.decoradiobutton2,'value');
           handles.msdflag=get (handles.msdflagradiobutton1,'value');
           
           handles.file=get(handles.fileedit12,'string');
           handles.detectpk=get(handles.deteckpeakradiobutton4,'value');
    guidata(gcbo,handles) ;

    prompt = {'New parameters'};
    num_lines= 1;
    dlg_title = 'Input file name';
    def = {''}; % default value
    ans  = inputdlg(prompt,dlg_title,num_lines,def);
    exit=size(ans);
    if exit(1) == 0;
       disp ('Nothing new saved!');
       return; 
    end
    name=ans{1};
    savepath = ['\MATLAB6p5p1\ProcedureLC\kakao\',name,'.par'];
    
    saveparameters(savepath,handles);
    %end




