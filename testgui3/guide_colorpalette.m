function varargout = guide_colorpalette(varargin)
%GUIDE_COLORPALETTE M-file for guide_colorpalette.fig
%      GUIDE_COLORPALETTE, by itself, creates a new GUIDE_COLORPALETTE or raises the existing
%      singleton*.
%
%      H = GUIDE_COLORPALETTE returns the handle to a new GUIDE_COLORPALETTE or the handle to
%      the existing singleton*.
%
%      GUIDE_COLORPALETTE('Property','Value',...) creates a new GUIDE_COLORPALETTE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to guide_colorpalette_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUIDE_COLORPALETTE('CALLBACK') and GUIDE_COLORPALETTE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUIDE_COLORPALETTE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guide_colorpalette

% Copyright 1984-2007 The MathWorks, Inc.
% Last Modified by GUIDE v2.5 28-Jun-2010 11:40:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guide_colorpalette_OpeningFcn, ...
                   'gui_OutputFcn',  @guide_colorpalette_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before guide_colorpalette is made visible.
function guide_colorpalette_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for guide_colorpalette
handles.output = hObject;

handles.iconEditor = [];

iconEditorInput = find(strcmp(varargin, 'iconEditor'));
if ~isempty(iconEditorInput)
   handles.iconEditor = varargin{iconEditorInput+1};
end

handles.mSelectedColor = [0 0 0];
% make the selected color available to others, such as iconEditor
handles.setColor = @setSelectedColor;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = guide_colorpalette_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonMoreColors.
function buttonMoreColors_Callback(hObject, eventdata, handles)
% Callback called when the more color button is pressed. 
color = handles.mSelectedColor;
if isnan(color)
    color =[0 0 0];
end
color = uisetcolor(color);
if ~isequal(color, handles.mSelectedColor)
    setSelectedColor(hObject, color);                        
end

%----------------------------------------------------------------------
function colorCellCallback(hObject, eventdata, handles)
% Callback called when any color cell button is pressed
setSelectedColor(hObject, get(hObject, 'BackgroundColor'));
fig = hObject;
while(~strcmp(fig.Type,'figure'))
	fig = get(fig,'Parent');
end
set(fig,'pointer','arrow');

% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% Don't close this figure. It must be deleted from iconEditor


%----------------------------------------------------------------------
%----------------------------------------------------------------------
%           Non GUI Callback Functions
%----------------------------------------------------------------------
%----------------------------------------------------------------------
function localUpdateColor(handles)
% helper function that updates the preview of the selected color
set(handles.selectedColorText, 'BackgroundColor', handles.mSelectedColor);
set(handles.redValueText, 'String',['R: ' num2str(handles.mSelectedColor(1))]);
set(handles.greenValueText,'String',['G: ' num2str(handles.mSelectedColor(2))]);
set(handles.blueValueText,'String',['B: ' num2str(handles.mSelectedColor(3))]);

%----------------------------------------------------------------------
% function set the selected color in this colorPalatte
function setSelectedColor(hObject, color)
handles = guidata(hObject);
handles.mSelectedColor =color;
localUpdateColor(handles);
guidata(hObject, handles);
