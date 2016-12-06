function varargout = guide_toolpalette(varargin)
%GUIDE_TOOLPALETTE M-file for guide_toolpalette.fig
%      GUIDE_TOOLPALETTE, by itself, creates a new GUIDE_TOOLPALETTE or raises the existing
%      singleton*.
%
%      H = GUIDE_TOOLPALETTE returns the handle to a new GUIDE_TOOLPALETTE or the handle to
%      the existing singleton*.
%
%      GUIDE_TOOLPALETTE('Property','Value',...) creates a new GUIDE_TOOLPALETTE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to guide_toolpalette_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUIDE_TOOLPALETTE('CALLBACK') and GUIDE_TOOLPALETTE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUIDE_TOOLPALETTE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guide_toolpalette

% Copyright 1984-2007 The MathWorks, Inc.
% Last Modified by GUIDE v2.5 28-Jun-2010 11:43:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guide_toolpalette_OpeningFcn, ...
                   'gui_OutputFcn',  @guide_toolpalette_OutputFcn, ...
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


% --- Executes just before guide_toolpalette is made visible.
function guide_toolpalette_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for guide_toolpalette
handles.output = hObject;


% Initialize the tool palette objects
handles.mCurrentTool = [];
handles.iconEditor = [];

iconEditorInput = find(strcmp(varargin, 'iconEditor'));
if ~isempty(iconEditorInput)
   handles.iconEditor = varargin{iconEditorInput+1};
end

handles.mCurrentTool = handles.toolPencil;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = guide_toolpalette_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function toolPencil_CreateFcn(hObject, eventdata, handles)
set(hObject,'UserData', struct('Callback', @pencilToolCallback));

function toolEraser_CreateFcn(hObject, eventdata, handles)
set(hObject,'UserData', struct('Callback', @eraserToolCallback));

function toolBucket_CreateFcn(hObject, eventdata, handles)
set(hObject,'UserData', struct('Callback', @bucketToolCallback));

function toolPicker_CreateFcn(hObject, eventdata, handles)
set(hObject,'UserData', struct('Callback', @colorpickerToolCallback));


% --- Executes when selected object is changed in toolPalette.
function toolPalette_SelectionChangeFcn(hObject, eventdata, handles)
% update the selected tool of iconEditor
handles.mCurrentTool = hObject;
guidata(hObject, handles);

% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% Don't close this figure. It must be deleted from iconEditor



%----------------------------------------------------------------------
%           Non GUI Callback Functions
%----------------------------------------------------------------------
function [iconEditor, iconEditorHandles] = getIconEditor(handles)
iconEditor = handles.iconEditor;
iconEditorHandles = [];
if ishandle(handles.iconEditor)
    iconEditorHandles = guidata(handles.iconEditor);
end

function cdata = pencilToolCallback(handles, toolstruct, cdata, point)
% Callback called when the eraser palette tool button is pressed
[iconEditor, iconEditorHandles] = getIconEditor(handles);
x = ceil(point(1,1));
y = ceil(point(1,2));

% update color of the selected block
if ~isempty(iconEditorHandles) && isfield(iconEditorHandles, 'getColor')
	color = iconEditorHandles.getColor(iconEditor);
    cdata(y, x,:) = color;
end

%----------------------------------------------------------------------
function cdata = eraserToolCallback(handles, toolstruct, cdata, point)
% Callback called when the eraser palette tool button is pressed
x = ceil(point(1,1));
y = ceil(point(1,2));
cdata(y, x,:) = [NaN, NaN, NaN];

%----------------------------------------------------------------------
function cdata = bucketToolCallback(handles, toolstruct, cdata, point)
% Callback called when the bucket palette tool button is pressed
[iconEditor, iconEditorHandles] = getIconEditor(handles);
x = ceil(point(1,1));
y = ceil(point(1,2));

rows = size(cdata,1);
cols = size(cdata,2);
color =[];
        
if ~isempty(iconEditorHandles) && isfield(iconEditorHandles, 'getColor')
    % obtain the selected color in ColorPalette
    color = iconEditorHandles.getColor(iconEditor);
    if ~isempty(color) && ~isequal(color, reshape(cdata(y,x,:), size(color)))
        cdata = fillWithColor(cdata, rows, cols, color, x,y,cdata(y,x,:));
    end
end

function cdata = fillWithColor(cdata, rows, cols, color, row, col, seedcolor)
% fill this color first
cdata(col,row,:) =color;
            
% look for for four neighbors
match = [];
neighbors =[row, col-1;
            row, col+1;
            row-1, col;
            row+1, col];
for i=1:length(neighbors)
	if (neighbors(i,2)>0 && neighbors(i,2)<=rows) ...
            && (neighbors(i,1)>0 && neighbors(i,1)<=cols) 
        thiscolor = cdata(neighbors(i,2), neighbors(i,1),:);                        
        if isequal(thiscolor, seedcolor) || ...
            ((isnan(thiscolor(1)) && isnan(seedcolor(1))) ...
            || (isnan(thiscolor(2)) && isnan(seedcolor(2))) ...                            
            || (isnan(thiscolor(3)) && isnan(seedcolor(3))))

            match(end+1) = i;
        end
	end
end

% if we have match, go to the matched locations
if ~isempty(match)
	for i=1:length(match)
        cdata = fillWithColor(cdata, rows, cols, color, ...
            neighbors(match(i),1), neighbors(match(i),2), seedcolor);
	end
end


%----------------------------------------------------------------------
function cdata = colorpickerToolCallback(handles, toolstruct, cdata, point)
% Callback called when the color picker palette tool button is pressed
[iconEditor, iconEditorHandles] = getIconEditor(handles);
x = ceil(point(1,1));
y = ceil(point(1,2));

if ~isempty(iconEditorHandles) && isfield(iconEditorHandles,'setColor')
	color = cdata(y, x,:);
	if isempty(find(isnan(color), 1))
        % change the selected color in ColorPalette
        iconEditorHandles.setColor(iconEditor,color);
	end
end  
