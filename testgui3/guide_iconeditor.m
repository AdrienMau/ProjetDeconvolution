function varargout = guide_iconeditor(varargin)
%GUIDE_ICONEDITOR M-file for guide_iconeditor.fig
%      GUIDE_ICONEDITOR, by itself, creates a new GUIDE_ICONEDITOR or raises the existing
%      singleton*.
%
%      H = GUIDE_ICONEDITOR returns the handle to a new GUIDE_ICONEDITOR or the handle to
%      the existing singleton*.
%
%      GUIDE_ICONEDITOR('Property','Value',...) creates a new GUIDE_ICONEDITOR using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to guide_iconeditor_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUIDE_ICONEDITOR('CALLBACK') and GUIDE_ICONEDITOR('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUIDE_ICONEDITOR.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guide_iconeditor

% Copyright 1984-2007 The MathWorks, Inc.
% Last Modified by GUIDE v2.5 28-Jun-2010 11:37:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guide_iconeditor_OpeningFcn, ...
                   'gui_OutputFcn',  @guide_iconeditor_OutputFcn, ...
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


% --- Executes just before guide_iconeditor is made visible.
function guide_iconeditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

handles.mIconWidth = 16;
handles.mIconHeight = 16;
handles.mIconCData = [];
handles.mIconFile = fullfile(matlabroot,'toolbox/matlab/icons/'); 
handles.mIsMouseDown = false;

% start colorPalette, initialize its selected color, and keep the handle to
% its figure so that the handles structure of colorPalette can be obtained
% when needed
colorPalette = guide_colorpalette('iconEditor', hObject);
colorPaletteHandles = guidata(colorPalette);
colorPaletteHandles.setColor(colorPalette, [1 0 0]);
handles.colorPalette = colorPalette;

% start toolPalette and keep the handle to its figure so that the handles
% structure of toolPalette can be obtained when needed
toolPalette = guide_toolpalette('iconEditor', hObject);
handles.toolPalette = toolPalette;

% make get/set the selected color of colorPalette available to others, such
% as toolPalette
handles.getColor = @getColor;
handles.setColor = @setColor;

localUpdateIconPlot(handles);

% Update handles structure
guidata(hObject, handles);

uiwait(hObject);

% --- Outputs from this function are returned to the command line.
function varargout = guide_iconeditor_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.mIconCData;
delete(handles.toolPalette);
delete(handles.colorPalette);
delete(hObject);

% --- Executes during object creation, after setting all properties.
function editFilename_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(groot,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in buttonImport.
function buttonImport_Callback(hObject, eventdata, handles)
% Callback called when the icon file selection button is pressed
filespec = {'*.mat; *.bmp; *.jpg; *.tif; *.gif; *.png', 'All image files';...
	'*.mat', 'MATLAB MAT files (*.mat)';...
	'*.bmp', 'BMP files (*.bmp)'; ...
	'*.jpg', 'JPEG files (*.jpg)';...
	'*.tif', 'TIFF files (*.tif)';
	'*.gif', 'GIF files (*.gif)';...
	'*.png', 'PNG files (*.png)'};
[filename, pathname] = uigetfile(filespec, 'Pick an icon image file', handles.mIconFile);

if ~isequal(filename,0)
	handles.mIconFile =fullfile(pathname, filename);             
	set(handles.editFilename, 'ButtonDownFcn',[]);            
	set(handles.editFilename, 'Enable','on');            
            
	handles.mIconCData = [];
    localUpdateIconPlot(handles);            
            
elseif isempty(handles.mIconCData)
	set(handles.iconPreview,'Visible', 'off');            
end


% --- Executes on button press in buttonOK.
function buttonOK_Callback(hObject, eventdata, handles)
uiresume(handles.figure);

% --- Executes on button press in buttonCancel.
function buttonCancel_Callback(hObject, eventdata, handles)
handles.mIconCData =[];
guidata(handles.figure, handles);
uiresume(handles.figure);

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over editFilename.
function editFilename_ButtonDownFcn(hObject, eventdata, handles)
% Callback called the first time the user pressed mouse on the icon
% file editbox 
set(hObject,'String','');
set(hObject,'Enable','on');
set(hObject,'ButtonDownFcn',[]);        
uicontrol(hObject);
handles.mIsMouseDown = false;
guidata(hObject, handles);



function editFilename_Callback(hObject, eventdata, handles)
% Callback called when user has changed the icon file name from which
% the icon can be loaded
file = get(hObject,'String');
if exist(file, 'file') ~= 2
	errordlg(['The given icon file cannot be found ' 10, file], ...
                'Invalid Icon File', 'modal');
	set(hObject, 'String', handles.mIconFile);
else
	handles.mIconCData = [];
    handles.mIconFile = file;
	localUpdateIconPlot(handles);
end

% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
uiresume(hObject);

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_WindowButtonDownFcn(hObject, eventdata, handles)
% Callback called when mouse is pressed on the figure. Used to change
% the color of the specific icon data point under the mouse to that of
% the currently selected color of the colorPalette
handles.mIsMouseDown = true;
guidata(hObject, handles);
applyCurrentTool(handles);

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_WindowButtonUpFcn(hObject, eventdata, handles)
% Callback called when mouse is release to exit the icon editing mode
handles.mIsMouseDown = false;
guidata(hObject, handles);

% --- Executes on mouse motion over figure - except title and menu.
function figure_WindowButtonMotionFcn(hObject, eventdata, handles)
% Callback called when mouse is moving so that icon color data can be
% updated in the editing mode
applyCurrentTool(handles);


%----------------------------------------------------------------------
%----------------------------------------------------------------------
%           Non GUI Callback Functions
%----------------------------------------------------------------------
%----------------------------------------------------------------------

% Get the tool palette
function [toolPalette, toolPaletteHandles] = getToolPalette(handles)
toolPalette = handles.toolPalette;
toolPaletteHandles = [];
% Make sure the figure is still valid first
if ishandle(handles.toolPalette)
    toolPaletteHandles = guidata(handles.toolPalette);
end

% Get the color palette
function [colorPalette, colorPaletteHandles] = getColorPalette(handles)
colorPalette = handles.colorPalette;
colorPaletteHandles = [];
% Make sure the figure is still valid first
if ishandle(handles.colorPalette)
    colorPaletteHandles = guidata(handles.colorPalette);
end


%----------------------------------------------------------------------

% Set the selected color in the color palette
function setColor(hObject, color)
% update the selected color of color palette
handles = guidata(hObject);
[colorPalette, colorPaletteHandles] = getColorPalette(handles);
if isfield(colorPaletteHandles, 'setColor')                
	colorPaletteHandles.setColor(colorPalette, color);
end

% Get the selected color in the color palette
function color = getColor(hObject)
% get the current selected color of color palette
handles = guidata(hObject);
[colorPalette, colorPaletteHandles] = getColorPalette(handles);
color = [];
if isfield(colorPaletteHandles, 'mSelectedColor')
	color = colorPaletteHandles.mSelectedColor;
end

%----------------------------------------------------------------------
function updateCursor(hObject, overicon)
handles = guidata(hObject);
if ~overicon
    set(hObject,'pointer','arrow');        
else
    [toolPalette, toolPaletteHandles] = getToolPalette(handles);
    if ~isempty(toolPaletteHandles) && isfield(toolPaletteHandles, 'mCurrentTool')
        tool = toolPaletteHandles.mCurrentTool;
        cdata = round(mean(get(tool, 'cdata'),3))+1;
        if ~isempty(cdata)
            set(hObject,'pointer','custom','PointerShapeCData',cdata(1:16, 1:16),'PointerShapeHotSpot',[16 1]);        
        end
    end
end


%------------------------------------------------------------------
function applyCurrentTool(handles)
% helper function that changes the color of an icon data point to
% that of the currently selected color in colorPalette 
[toolPalette, toolPaletteHandles] = getToolPalette(handles);
rows = size(handles.mIconCData,1);
cols = size(handles.mIconCData,2);
pt = get(handles.icon,'currentpoint');
overicon =  (pt(1,1)>=0 && pt(1,1)<=rows) && (pt(1,2)>=0 && pt(1,2)<=cols);
updateCursor(handles.figure, overicon);
if overicon && handles.mIsMouseDown
    if isfield(toolPaletteHandles, 'mCurrentTool') && ishandle(toolPaletteHandles.mCurrentTool)
        x = ceil(pt(1,1));
        y = ceil(pt(1,2));
        if (x>0 && x<=cols) && (y>=0 && y<=rows)
            % get the function of the currently selected tool in the
            % toolPalette and call it.
            userData = get(toolPaletteHandles.mCurrentTool, 'UserData');
            if ~isempty(userData) && isfield(userData,'Callback')
                handles.mIconCData = userData.Callback(toolPaletteHandles, toolPaletteHandles.mCurrentTool, handles.mIconCData, pt);
            end
        end
    end
end

localUpdateIconPlot(handles);

    
%------------------------------------------------------------------
function localUpdateIconPlot(handles)
% helper function that updates the figure when the icon data
% changes
%initialize icon CData if it is not initialized
if isempty(handles.mIconCData)
	if exist(handles.mIconFile, 'file')==2
        try
            handles.mIconCData = guide_iconRead(handles.mIconFile);
            set(handles.editFilename, 'String',handles.mIconFile);            
        catch
            errordlg(['Could not load icon data from given file successfully. ',...
                'Make sure the file name is correct: ' 10, handles.mIconFile],...
                'Invalid Icon File', 'modal');
            handles.mIconCData = nan(handles.mIconHeight, handles.mIconWidth, 3);
        end
    else 
        handles.mIconCData = nan(handles.mIconHeight, handles.mIconWidth, 3);
	end
else
	% this is for passing in the cdata
	iconsize = size(handles.mIconCData);
	if length(iconsize) == 2
        data(:,:,1) = handles.mIconCData;
        data(:,:,2) = handles.mIconCData;
        data(:,:,3) = handles.mIconCData;
        handles.mIconCData = data;
	end
	handles.mIconHeight = size(handles.mIconCData,1);
	handles.mIconWidth = size(handles.mIconCData,2);
end
        
% update preview control
rows = size(handles.mIconCData, 1);
cols = size(handles.mIconCData, 2);
previewSize = getpixelposition(handles.previewPanel);
% compensate for the title
previewSize(4) = previewSize(4) -15;
controlWidth = previewSize(3);
controlHeight = previewSize(4);  
controlMargin = 6;
if rows+controlMargin<controlHeight
	controlHeight = rows+controlMargin;
end
if cols+controlMargin<controlWidth
	controlWidth = cols+controlMargin;
end        
setpixelposition(handles.iconPreview,[(previewSize(3)-controlWidth)/2,(previewSize(4)-controlHeight)/2, controlWidth, controlHeight]); 
set(handles.iconPreview,'CData', handles.mIconCData,'Visible','on');
        
% update icon edit pane
set(handles.editPanel, 'Title',['Icon Edit Pane (', num2str(rows),' X ', num2str(cols),')']);
        
s = findobj(handles.editPanel,'type','surface');        
if isempty(s)
	gridColor = get(groot, 'defaultuicontrolbackgroundcolor') + 0.1;
    gridColor(gridColor>1)=1;
	s(1)=surface('edgecolor','none','parent',handles.icon, 'Tag','TransparentLayer');
    s(2)=surface('edgecolor',gridColor,'parent',handles.icon, 'Tag','IconLayer');
end        
%set xdata, ydata, zdata in case the rows and/or cols change
canvas = findobj(s,'Tag','IconLayer');
set(canvas,'xdata',0:cols,'ydata',0:rows,'zdata',zeros(rows+1,cols+1),'cdata',localGetIconCDataWithNaNs(handles));
transparent = findobj(s,'Tag','TransparentLayer');
y=ones((2*rows+1)*(2*cols+1),3);
y(1:2:(2*rows+1)*(2*cols+1), :)= 0.6;
y(2:2:(2*rows+1)*(2*cols+1), :)= 0.7;
y=reshape(y, [2*rows+1,2*cols+1,3]);
set(transparent,'xdata',0:0.5:cols,'ydata',0:0.5:rows,'zdata',zeros(2*rows+1,2*cols+1),'cdata',y);        

set(handles.icon,'xlim',[-.5 cols+.5],'ylim',[-.5 rows+.5]);
axis(handles.icon, 'ij', 'off');
set(handles.icon,'SortMethod','childorder');
guidata(handles.figure, handles);
%set(canvas,'ButtonDownFcn','disp down')

%------------------------------------------------------------------
function cdwithnan = localGetIconCDataWithNaNs(handles)
% Add NaN to edge of mIconCData so the entire icon renders in the
% drawing pane.  This is necessary because of surface behavior.
cdwithnan = handles.mIconCData;
cdwithnan(:,end+1,:) = NaN;
cdwithnan(end+1,:,:) = NaN;
