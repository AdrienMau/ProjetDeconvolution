%Utiliser des cellules pour enregistrer  les images ?
% plus souple pour appel (pas de switch case)

function varargout = Farview(varargin)
% FARVIEW MATLAB code for Farview.fig
%      FARVIEW, by itself, creates a new FARVIEW or raises the existing
%      singleton*.
%
%      H = FARVIEW returns the handle to a new FARVIEW or the handle to
%      the existing singleton*.
%
%      FARVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FARVIEW.M with the given input arguments.
%
%      FARVIEW('Property','Value',...) creates a new FARVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Farview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Farview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Farview

% Last Modified by GUIDE v2.5 05-Dec-2016 15:32:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Farview_OpeningFcn, ...
                   'gui_OutputFcn',  @Farview_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Farview is made visible.
function Farview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Farview (see VARARGIN)

%VARIABLES
handles.imageisloaded=0;
handles.folderpath='No Path Chosen';
handles.chosenimage=1;  %premiere liste
handles.chosenimage2=1; %deuxieme liste
% handles.switchaxes=1; %varie entre axes 1 et 2 pour afficher images

handles.slider_lambda=1;
handles.slider_radius=1;
handles.slider_seuil=1;



% Choose default command line output for Farview
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Farview wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Farview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% LOAD & PATH

% --- CHARGEMENT IMAGE
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.folder_cal=uigetdir;
% guidata(hObject,handles); %sauvegarde le nouveau handle
% set(handles.edit_path, 'String', handles.folder_cal);

try
    [NomFic,NomEmp] = uigetfile({'*';'*.jpg';'*.png';'*.bmp'},'Choisissez une image',get(handles.edit_showpath,'String')); % Choisir une image 
catch
    [NomFic,NomEmp] = uigetfile({'*';'*.jpg';'*.png';'*.bmp'},'Choisissez une image'); % Choisir une image 
end
if(NomFic) %if a file has been chosen
    %CHARGEMENT IMAGE
        if(NomFic(end-3:end)=='.dat')
            %ouverture avec trackread
            [a,fun]=trackread(NomFic);
            img=(calcR(a)); %double
        else
            img=double(imread(strcat(NomEmp,NomFic)));
            try %if image has multiple arrays
                img=(img(:,:,1)+img(:,:,2)+img(:,:,3))/3/255; % 1:3 because of problem with tiff image
                %si img est double, rgb2gray donnera que des 1...
                'conversion en gris'
            end
        end
    
    % ON ATTRIBUE L'IMAGE A LIMAGE SELECTIONNEE DANS LISTE
    handles.img{handles.chosenimage}=img;
    if((handles.imageisloaded==0)&(handles.chosenimage==1))
        %si on a encore rien chargé et laissé par défaut, on charge dans
        %deux images (juste pour coté pratique)
        handles.img{2}=img;
        axes(handles.axes2)
        imshow(img)
    end
    axes(handles.axes1)
    imshow(img); title(NomFic);
    
    handles.folderpath=NomEmp;

    handles.imageisloaded=1;
    guidata(hObject,handles)

	addpath(NomEmp)
    set(handles.edit_showpath,'String',NomEmp);
    
end

function edit_showpath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_showpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_showpath as text
%        str2double(get(hObject,'String')) returns contents of edit_showpath as a double
handles.folderpath=get(hObject,'String');

% --- Executes during object creation, after setting all properties.
function edit_showpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_showpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Basics

% --- Executes on button press in pushbutton_trapide.
function pushbutton_trapide_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_trapide (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
'lancement Traitement rapide'


% --- Choix d'une image dans la liste:
function listbox_img_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_img contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_img
% contents = cellstr(get(hObject,'String'))
contents = cellstr(get(hObject,'String'));

choice=contents{get(hObject,'Value')}
choice2=(choice(end)); %number of image chosen - string
choice3=str2num(choice2);
handles.chosenimage=choice3;

% handles.switchaxes=mod(handles.switchaxes,2)+1; % on alterne pour afficher: 1 donne 2, 2 donne 1
% 
% %Affichage
% switch handles.switchaxes
%     case 1
%         axes(handles.axes1)
%     case 2
%         axes(handles.axes2)
% end
% choice3
axes(handles.axes1)
try
imshow(handles.img{choice3});
title(['image',choice2]);
end
guidata(hObject, handles);


guidata(hObject, handles);


% --- Liste des images
function listbox_img_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in listbox_out.
function listbox_out_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_out contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_out
contents = cellstr(get(hObject,'String'));
choice=contents{get(hObject,'Value')}
choice2=(choice(end)); %number of image chosen - string
choice3=str2num(choice2);
handles.chosenimage2=choice3;
% handles.switchaxes=mod(handles.switchaxes,2)+1; % on alterne pour afficher: 1 donne 2, 2 donne 1
% 
% %Affichage
% switch handles.switchaxes
%     case 1
%         axes(handles.axes1)
%     case 2
%         axes(handles.axes2)
% end
% % choice3
axes(handles.axes2)
try
imshow(handles.img{choice3});
title(['image',choice2]);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox_out_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% Basic operations

% --- Executes on button press in pushbutton_show.
function pushbutton_show_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_show (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure
imshow(handles.img{handles.chosenimage})



% --- Executes on button press in pushbutton_contrast.
function pushbutton_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        figure(1)
        imshow(uint8(handles.img{handles.chosenimage}*255))
        imcontrast(gcf);
        uiwait
        F=getframe();
        test=frame2im(F);
        handles.img{handles.chosenimage}=double(test(:,:,1))/255;
%         handles.img{handles.chosenimage}=F.cdata;

        axes(handles.axes1)
        imshow(F.cdata)
        close(figure(1))
guidata(hObject, handles);


% --- Executes on button press in pushbutton_crop.
function pushbutton_crop_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

figure
        imshow(handles.img{handles.chosenimage})
        img=imcrop(handles.img{handles.chosenimage})
        handles.img{handles.chosenimage}=img;

        axes(handles.axes1)
        imshow(img)
guidata(hObject, handles);


% --- Executes on button press in pushbutton_neg.
function pushbutton_neg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img=handles.img{handles.chosenimage};
img=1-img;
handles.img{handles.chosenimage}=img;
guidata(hObject, handles);
axes(handles.axes1)
imshow(img)



% --- Executes on button press in pushbutton_gradient.
function pushbutton_gradient_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_gradient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imgtemp=(handles.img{handles.chosenimage});
% [gx,gy]=gradient(double(imgtemp));
[gx,gy]=gradient((imgtemp));
imgtemp=(abs(gx+i*gy));
handles.img{handles.chosenimage}=(imgtemp); %pb sur ce qu'on affiche en double ou uint8
% handles.img{handles.chosenimage}=sqrt(gx.^2+gy.^2); %idem
axes(handles.axes1)
imshow(imgtemp)
guidata(hObject, handles);






% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes on button press in pushbutton_deconv.
function pushbutton_deconv_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_deconv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
'lancement Deconvolution -----'

img=handles.img{handles.chosenimage};

%param wiener
n=handles.slider_radius;
n=3
lambda=handles.slider_lambda;
%PSF et D:
x = -n:n; x=exp(-x.*x/n);
RI=transpose(x)*x;
D = [0.01,0.2,0.01;0.2,4,0.2;0.01,0.2,0.01];


imgout=filtreWiener(img,RI,D,lambda);
handles.img{handles.chosenimage2}=imgout;
guidata(hObject, handles);
%display

axes(handles.axes2)
imshow(imgout)



% --- Executes on button press in pushbutton_contours.
function pushbutton_contours_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_contours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
'lancement algo Contours -----'

img=handles.img{handles.chosenimage};

%%% ALGO %%%

% handles.img{handles.chosenimage2}=imgout;


% --- Executes on button press in pushbutton_arrow.
function pushbutton_arrow_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_arrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.img{handles.chosenimage2}=handles.img{handles.chosenimage};
guidata(hObject, handles);
axes(handles.axes2)
imshow(handles.img{handles.chosenimage2})
title(['image',num2str(handles.chosenimage2)])


%% SLIDERS

% --- Executes on slider movement.
function slider_lambda_Callback(hObject, eventdata, handles)
% hObject    handle to slider_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 value=(get(hObject, 'Value')); 

 handles.slider_lambda = value;
 set(handles.text_slider_lambda,'String',num2str(value)); %texte àcoté
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider_lambda_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_lambda (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% set the slider range and step size
 numSteps = 200;
 set(hObject, 'Min', 0);
 set(hObject, 'Max', 1);
 set(hObject, 'Value', 1);
 set(hObject, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
 % save the current/last slider value
 handles.slider_lambda = 1;
 % Update handles structure
 guidata(hObject, handles);
 
 
% --- Executes on slider movement.
function slider_radius_Callback(hObject, eventdata, handles)
% hObject    handle to slider_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 value=(get(hObject, 'Value')); 

 handles.slider_radius = value;
 set(handles.text_slider_radius,'String',num2str(value)); %texte àcoté
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider_radius_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_radius (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
% set the slider range and step size
 numSteps = 500;
 set(hObject, 'Min', 0);
 set(hObject, 'Max', 20);
 set(hObject, 'Value', 1);
 set(hObject, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
 % save the current/last slider value
 handles.slider_radius = 1;
 % Update handles structure
 guidata(hObject, handles);


% --- Executes on slider movement.
function slider_seuil_Callback(hObject, eventdata, handles)
% hObject    handle to slider_seuil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
 value=(get(hObject, 'Value')); 

 handles.slider_seuil = value;
 set(handles.text_slider_seuil,'String',num2str(value)); %texte àcoté
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider_seuil_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_seuil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
 numSteps = 510;
 set(hObject, 'Min', 0);
 set(hObject, 'Max', 255);
 set(hObject, 'Value', 1);
 set(hObject, 'SliderStep', [1/(numSteps-1) , 1/(numSteps-1) ]);
 % save the current/last slider value
 handles.slider_seuil = 1;
 % Update handles structure
 guidata(hObject, handles);


 %% FIN SLIDER
 
 
 

