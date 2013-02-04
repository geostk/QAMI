function varargout = HighQualitySelection(varargin)
% HIGHQUALITYSELECTION M-file for HighQualitySelection.fig
%      HIGHQUALITYSELECTION, by itself, creates a new HIGHQUALITYSELECTION or raises the existing
%      singleton*.
%
%      H = HIGHQUALITYSELECTION returns the handle to a new HIGHQUALITYSELECTION or the handle to
%      the existing singleton*.
%
%      HIGHQUALITYSELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HIGHQUALITYSELECTION.M with the given input arguments.
%
%      HIGHQUALITYSELECTION('Property','Value',...) creates a new HIGHQUALITYSELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HighQualitySelection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HighQualitySelection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HighQualitySelection

% Last Modified by GUIDE v2.5 03-Feb-2013 15:00:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HighQualitySelection_OpeningFcn, ...
                   'gui_OutputFcn',  @HighQualitySelection_OutputFcn, ...
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


% --- Executes just before HighQualitySelection is made visible.
function HighQualitySelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HighQualitySelection (see VARARGIN)

% Choose default command line output for HighQualitySelection
%todo:1. prepair the arguments,dcmInfo,curIndex
%todo:2. show the first two images
%todo:3. initialize the slider

handles.output = hObject;
handles.dcmInfo = varargin;
n = length(handles.dcmInfo);
handles.curIndex = 1;
guidata(hObject,handles);

isSuccess = loadDcmImages(handles);
if isSuccess == 0
    close gcf;
    return;
end

min = 1;
max = n;
set(handles.sldBrowse,'Min',min);
set(handles.sldBrowse,'Max',max);
set(handles.sldBrowse,'sliderstep',[2/(max-min) 2/(max-min)]);
set(handles.sldBrowse,'value',1);


% UIWAIT makes HighQualitySelection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HighQualitySelection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnLeft.
function btnLeft_Callback(hObject, eventdata, handles)
% hObject    handle to btnLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%todo:1. set the new curIndex
%todo:2. show the images
%todo:3. if failed, reset the curIndex;
%todo:4. update the slider

handles.curIndex = handles.curIndex - 2;

isSuccess = loadDcmImages(handles);

if isSuccess == 0
    handles.curIndex = handles.curIndex + 2;
end

set(handles.sldBrowse,'value',handles.curIndex);
guidata(hObject,handles);

% --- Executes on button press in btnRight.
function btnRight_Callback(hObject, eventdata, handles)
% hObject    handle to btnRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%todo:1. set the new curIndex
%todo:2. show the images
%todo:3. if failed, reset the curIndex;
%todo:4. update the slider

handles.curIndex = handles.curIndex + 2;

isSuccess = loadDcmImages(handles);

if isSuccess == 0
    handles.curIndex = handles.curIndex - 2;
end

set(handles.sldBrowse,'value',handles.curIndex);
guidata(hObject,handles);

% --- Executes on slider movement.
function sldBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to sldBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%todo:1. get the value
%todo:2. set the curIndex
%todo:3. reload the images

sldValue = get(hObject,'Value');

handles.curIndex = round(sldValue);

isSuccess = loadDcmImages(handles);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sldBrowse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in ckbLeft.
function ckbLeft_Callback(hObject, eventdata, handles)
% hObject    handle to ckbLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckbLeft


% --- Executes on button press in ckbRight.
function ckbRight_Callback(hObject, eventdata, handles)
% hObject    handle to ckbRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckbRight

function [isSuccess] = loadDcmImages(handles)
%todo:1. get the dcmInfo, curIndex, etc.
%todo:2. test the validity
%todo:3. show the image(s)
%todo:4. update the text label above the images

dcmInfo = handles.dcmInfo;
curIndex = handles.curIndex;
index1 = curIndex;
index2 = index1 + 1;
n = length(dcmInfo);
isSuccess = 1;

if index1 > n || index1 < 1
    isSuccess = 0;
    return;
end
if index2 > n
    index2 = 0;
end

imgLeft = double(dicomread(dcmInfo{index1}));
if index2 > 0
    imgRight = double(dicomread(dcmInfo{index2}));
else
    imgRight = [];
end
imshow(imgLeft,[],'parent',handles.axesLeft);
imshow(imgRight,[],'parent',handles.axesRight);

set(handles.txtLeft,'string',['Piece ' num2str(index1)]);
if(index2 == 0)
    set(handles.txtRight,'string','');
else
    set(handles.txtRight,'string',['Piece ' num2str(index2)]);
end
