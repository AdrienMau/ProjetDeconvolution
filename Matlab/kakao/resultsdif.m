function varargout = resultsdif(varargin)
% RESULTSDIF M-file for resultsdif.fig
%      RESULTSDIF, by itself, creates a new RESULTSDIF or raises the existing
%      singleton*.
%
%      H = RESULTSDIF returns the handle to a new RESULTSDIF or the handle to
%      the existing singleton*.
%
%      RESULTSDIF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTSDIF.M with the given input arguments.
%
%      RESULTSDIF('Property','Value',...) creates a new RESULTSDIF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before resultsdif_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to resultsdif_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help resultsdif

% Last Modified by GUIDE v2.5 11-Feb-2005 10:22:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @resultsdif_OpeningFcn, ...
                   'gui_OutputFcn',  @resultsdif_OutputFcn, ...
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


% --- Executes just before resultsdif is made visible.
function resultsdif_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to resultsdif (see VARARGIN)

% Choose default command line output for resultsdif
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes resultsdif wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = resultsdif_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

set(handles.locradiobutton1,'value',0);
handles.option=get(handles.locradiobutton1,'value');
guidata(hObject, handles);



% --- Executes on button press in loadfilepushbutton1.
function loadfilepushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to loadfilepushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 set(handles.line1,'string','');
 set(handles.line2,'string','');
 set(handles.line3,'string','');
 set(handles.line4,'string','');
 set(handles.line5,'string','');


firstenter=1;
nroexp=1;
ex = 1;
ps = 1;
sy=1;
control=1;
option=handles.option;
extra=[];
peri=[];
synap=[];
total=[];


warning off MATLAB:MKDIR:DirectoryExists

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
directory_name = uigetdir(start_path,dialog_title);
if directory_name==0
    break
end

if option==1
     path=[directory_name,'\msd\cut\fits\'];
 else
     path=[directory_name,'\msd\fits\'];
 end

if control==1
    
  %choose data
  d = dir(path);
  st = {d.name};

  if isempty(st)==1
        msgbox(['Wrong folder, check kind of analysis'],'Saving parameters','error')
      return
  end
  
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
           extra (ex,:) = x (fila, :); 
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
m1=0;m2=0;m3=0;n1=0;n2=0;n3=0;

if option==1
    resextra = [name,'\extra.dat'];
    resperi = [name,'\peri.dat'];
    ressynap = [name,'\synap.dat'];
    
    if isempty(extra)==0
        save(resextra,'extra','-ascii') 
        x = load ([name,'\extra.dat']);
        [n1,m] = size (x);
        m1 = median ( x (:,2));
    end
    
    if isempty(perisyn)==0
        save(resperi,'perisyn','-ascii') 
        x = load ([name,'\peri.dat']);
       [n2,m] = size (x);
       m2 = median ( x (:,2));
    end
   
    if isempty(synaptic)==0
       save(ressynap,'synaptic','-ascii') 
       x = load ([name,'\synap.dat']);
       [n3,m] = size (x);
       m3 = median ( x (:,2));
    end

     
 set(handles.line1,'string',['Localization              Median D (µm²/s)            n']);
 set(handles.line2,'string',['Extrasynaptic:           ', num2str(m1),'                   ',num2str(n1)] );
 set(handles.line3,'string',['Perisynaptic:             ', num2str(m2),'                     ',num2str(n2)]);
 set(handles.line4,'string',['Synaptic:                   ', num2str(m3),'                      ',num2str(n3)]);
 
   guidata(hObject, handles);
 
else
   if isempty(total)==0
       res = [name,'\total.dat'];
       save(res,'total','-ascii') 
       x = load ([name,'\total.dat']);
       [n,m] = size (x);
       m = median ( x (:,2));
       
       set(handles.line1,'string',['Median D (µm²/s)                    n']);
      set(handles.line2,'string',[num2str(m),'                             ',num2str(n)] );
      set(handles.line5,'string',['File saved:',res]);
   end

   guidata(hObject, handles);

end

save([name,'\resdata.txt'],'analizados') 



% --- Executes on button press in locradiobutton1.
function locradiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to locradiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of locradiobutton1

handles.option=get(hObject,'value');
guidata(hObject, handles);


