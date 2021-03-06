function varargout = ui(varargin)
% UI M-file for ui.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ui

% Last Modified by GUIDE v2.5 19-Dec-2012 17:42:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ui_OpeningFcn, ...
                   'gui_OutputFcn',  @ui_OutputFcn, ...
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

% --- Executes just before ui is made visible.
function ui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ui (see VARARGIN)

handles.uidata=[];

handles.uidata=uidata();

handles.uidata.fileAmount = 0;
handles.uidata.timeNumber = 1;
handles.uidata.locationNumber = 1;
handles.uidata.showTimeNumber = 1;
handles.uidata.showLoctNumber = 1;
handles.uidata.canvasInitX = 200;
handles.uidata.canvasInitY = 0;
handles.uidata.canvasPosInv = 5;
handles.uidata.figureHeight = 250;
handles.uidata.figureWidth = 1200;
handles.uidata.curCanvas = 0;
handles.uidata.curSeries = 0;
handles.uidata.curSlice = 0;
handles.uidata.curSegSlice = 0;
handles.uidata.curSliceRoi = 0;
handles.uidata.curSelectedSeries = 0;
handles.uidata.curSelectedSlice = 0;
handles.uidata.contrast = 0;
handles.uidata.luminosity = 0;

handles.uidata.flagGoodQual = [];
handles.uidata.allRoi = [];
handles.uidata.curPt1 = [];
handles.uidata.curPt2 = [];
handles.uidata.isDrawingRoi = 0;
% Choose default command line output for ui
handles.output = hObject;
set(gcf,'DoubleBuffer','on');
%import the smiley image into matlab
%if image is not in the same directory as the GUI files, you must use the
%full path name of the image file
tglBtnZoomIn = importdata('icons\tool_zoom_in.png');
%tglBtnZoomOut = importdata('icons\tool_zoom_out.png');
tglBtnDataCursor = importdata('icons\tool_data_cursor.png');
% tglbtnzoom = importdata('tool_zoom_in.png');
% tglbtnzoom = importdata('tool_zoom_in.png');

%set the smiley image as the button background
set(handles.tglBtnZoom,'CDATA',im2double(tglBtnZoomIn.cdata));
%set(handles.tglBtnZoomReset,'CDATA',im2double(tglBtnZoomOut.cdata));
set(handles.tglBtnDataCursor,'CDATA',im2double(tglBtnDataCursor.cdata));
%hide the xticklabel and xytick.
set(handles.axesImg,'box','on','XTickLabel','','XTickLabel','','XTick',[],'YTick',[]);
addpath(genpath(pwd));
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in btnOpen.
function btnOpen_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Use file open dialog to get a file
if (~isempty(handles.uidata.pathName))
    [fname,pname]=uigetfile({'*.dcm','DICOM file'; '*.jpg;*.png', 'Image files'},'Please select a DICOM file.',handles.uidata.pathName);
else
    [fname,pname]=uigetfile({'*.dcm','DICOM file'; '*.jpg;*.png', 'Image files'},'Please select a DICOM file.');
end
tic
% Find files with the same extenstion and fill the list box
if ((fname~=0))
    handles.uidata.pathName = pname;
    
    % Find file extension
    [pathstr, aa, ext] = fileparts(strcat(pname, fname));
    if (~isempty(ext))
        extension=strcat('*', ext);
    else
        extension='*';
    end
    % Get file list
    dirFolder=strcat(pname,extension);
    FileList=dir(dirFolder);
    Total=length(FileList);
    n=0;
    index = 1;
    for k=1:1:Total
        if (~isdir(FileList(k).name))
            n=n+1;
            filename = {FileList(k).name};
            fileList(n)= filename;
            if strcmpi(filename, fname)
                index = k;
            end
        end        
    end
    handles.uidata.fileAmount = n;
    
    if (n>0)
        fileList = fileList(1:n);
        handles.uidata.fileNames = fileList;
        set(handles.lbFileList,'string',fileList);
        set(handles.lbFileList,'value', 1);
        set(handles.txtFileAmount,'string',['File Amount ' num2str(n)]);
        guidata(hObject, handles);
    end
    for i=1:n
        handles.uidata.dcmInfo{i} = dicominfo([pname fileList{i}]);
    end
    handles.uidata.timeNumber = handles.uidata.dcmInfo{1}.NumberOfTemporalPositions;
    handles.uidata.locationNumber = handles.uidata.dcmInfo{1}.ImagesInAcquisition/...
        handles.uidata.dcmInfo{1}.NumberOfTemporalPositions;
    set(handles.edtTimeNumber,'String',num2str(handles.uidata.timeNumber));
    set(handles.edtLocationNumber,'String',num2str(handles.uidata.locationNumber));
    
    tmpImg = dicomread(handles.uidata.dcmInfo{1});
    maxx = max(max(tmpImg));
    minn = min(min(tmpImg));
    set(handles.sldWinCenter,'value',(maxx-minn)/2.0+minn);
    set(handles.sldWinWidth,'value',maxx-minn); 
    
    handles.uidata.fileNamesIJ = cell(handles.uidata.timeNumber,handles.uidata.locationNumber);
    handles.uidata.fileNameOrderIJ = zeros(handles.uidata.timeNumber,handles.uidata.locationNumber);
    for i=1:n
        timeOrder = handles.uidata.dcmInfo{i}.TemporalPositionIdentifier;
        locaOrder = mod(handles.uidata.dcmInfo{i}.InstanceNumber,handles.uidata.locationNumber);
        if locaOrder==0
            locaOrder = 10;
        end
        handles.uidata.fileNamesIJ{timeOrder,locaOrder} = handles.uidata.fileNames{i};
        handles.uidata.fileNameOrderIJ(timeOrder,locaOrder) = i;
    end
    
    handles.uidata.curSeries = 1;
    handles.uidata.curSlice = 1;
    handles.uidata.allRoi = zeros(n,4);
    handles.uidata.flagGoodQual = zeros(handles.uidata.timeNumber,handles.uidata.locationNumber);
    handles = loadDcmImages(handles);
    set(handles.edtDispNumTime,'String',num2str(handles.uidata.curSeries));
    set(handles.edtDispNumLoc,'String',num2str(handles.uidata.curSlice));
    
    minValue = 1;
    maxValue = handles.uidata.locationNumber;
    set(handles.sldSlice,'min',minValue,'max',maxValue);
    set(handles.sldSlice,'sliderstep',[1/(maxValue-minValue) 1/(maxValue-minValue)]);
    set(handles.sldSlice,'value',maxValue);
    set(handles.sldSlice,'visible','on');
    minValue = 1;
    maxValue = n/handles.uidata.locationNumber;
    set(handles.sldSeries,'Min',minValue,'max',maxValue);
    set(handles.sldSeries,'sliderstep',[1/(maxValue-minValue) 1/(maxValue-minValue)]);
    set(handles.sldSeries,'value',minValue);
    set(handles.sldSeries,'visible','on');
%     %set the position of axes
%     set(handles.axesImg,'Position',[0.13 0.4 0.4 0.59]);
%     set(handles.axesStat,'Position',[0.57 0.4 0.4 0.59]);
    
    
    guidata(hObject,handles);
end
toc

% --- Executes on selection change in lbFileList.
function lbFileList_Callback(hObject, eventdata, handles)
% hObject    handle to lbFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbFileList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbFileList
%todo:1. get the index of selected image
%todo:2. update the curSeries and curSlice in handles.uidata
%todo:3. reload the image
%todo:4. update the text control edtDispNumLoc and edtDispNumTime and the
%        two sliders and reset tglBtnDrawRoi
singleIndex = get(hObject,'Value');

[curSlice curSeries] = singleInd2doubleInd(singleIndex,handles);
if handles.uidata.curSeries == curSeries && handles.uidata.curSlice == curSlice
    return;
end
handles.uidata.curSeries = curSeries;
handles.uidata.curSlice = curSlice;

handles = loadDcmImages(handles);

set(handles.edtDispNumLoc,'String',num2str(handles.uidata.curSlice));
set(handles.edtDispNumTime,'String',num2str(handles.uidata.curSeries));
set(handles.sldSeries,'value',curSeries);
minValue = get(handles.sldSlice,'min');
maxValue = get(handles.sldSlice,'max');
set(handles.sldSlice,'value',minValue + maxValue - curSlice);
set(handles.tglBtnDrawRoi,'Value',0);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function lbFileList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbFileList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtTimeNumber_Callback(hObject, eventdata, handles)
% hObject    handle to edtTimeNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtTimeNumber as text
%        str2double(get(hObject,'String')) returns contents of edtTimeNumber as a double


% --- Executes during object creation, after setting all properties.
function edtTimeNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtTimeNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edtLocationNumber_Callback(hObject, eventdata, handles)
% hObject    handle to edtLocationNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtLocationNumber as text
%        str2double(get(hObject,'String')) returns contents of edtLocationNumber as a double


% --- Executes during object creation, after setting all properties.
function edtLocationNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtLocationNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btnSaveRoiFlags.
function btnSaveRoiFlags_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveRoiFlags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pname = handles.uidata.pathName;
roi = handles.uidata.allRoi;
flags = handles.uidata.flagGoodQual;
save([pname 'roiflags.mat'],'roi','flags');


% --- Executes on button press in btnSetRoiFlags.
function btnSetRoiFlags_Callback(hObject, eventdata, handles)
% hObject    handle to btnSetRoiFlags (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pname = handles.uidata.pathName;
if exist([pname 'roiflags.mat'],'file')
    load([pname 'roiflags.mat']);
    handles.uidata.allRoi = roi;    
    handles.uidata.flagGoodQual = flags;  
    guidata(hObject,handles);
end
handles = loadDcmImages(handles);
guidata(hObject,handles);

% --- Executes on button press in btnSeg.
function btnSeg_Callback(hObject, eventdata, handles)
% hObject    handle to btnSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%todo:1. if there's roi in curimg,return
%todo:2. update handles.uidata.curSegSlice ,handles.uidata.curSliceRoi,set
%        the state of

curSeries = handles.uidata.curSeries;
curSlice = handles.uidata.curSlice;
curIndex = doubleInd2singleInd(curSlice,curSeries,handles);
curRoi = floor(handles.uidata.allRoi(curIndex,:));
if ~(curRoi(1) >= 0 && curRoi(2) > 0 && curRoi(3) > 0 && curRoi(4) > 0 && abs(curRoi(1) - curRoi(2))>0....
    && abs(curRoi(3) - curRoi(4)) > 0)
    return;
end

handles.uidata.curSegSlice = curSlice;
handles.uidata.curSliceRoi = curRoi;
set(handles.tglBtnSegShow,'Value',1);
handles = loadDcmImages(handles);
guidata(hObject,handles);

% --- Executes on button press in btnSaveSeg.
function btnSaveSeg_Callback(hObject, eventdata, handles)
% hObject    handle to btnSaveSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function [handles]=loadDcmImages(handles)
%todo:1. get the lumin,contrast,curSeries,curSlice,flagGoodQual,allRoi
%todo:2. set the min max property of sldWinWidth and sldWinCenter,respectively
%todo:3. process the oriImg according to the window width and window
%        center.if the image needs segment and the state of tglBtnSegShow is on
%        ,call ostu to get the threshold,select the object and set it to 
%        max value,then show it.
%todo:4. if the image was marked goodqual,draw the yellow box around it.
%        if the image has ori, draw ori box,update the ckbGoodQual
%        control,then display the histogram of the ori

curSeries = handles.uidata.curSeries;
curSlice = handles.uidata.curSlice;
curIndex = doubleInd2singleInd(curSlice,curSeries,handles);
curSegSlice = handles.uidata.curSegSlice;
% luminosity = handles.uidata.luminosity;
% contrasts = handles.uidata.contrast;
flagGoodQual = handles.uidata.flagGoodQual(curSeries,curSlice);
curRoi = floor(handles.uidata.allRoi(curIndex,:));
curSliceRoi = floor(handles.uidata.curSliceRoi);

oriImg = double(dicomread(handles.uidata.dcmInfo{curIndex}));
maxx=max(max(oriImg));
minn=min(min(oriImg));
set(handles.sldWinCenter,'max',maxx); 
set(handles.sldWinCenter,'min',minn); 
set(handles.sldWinWidth,'max',maxx-minn); 
set(handles.sldWinWidth,'min',0);         
tmpW =  get(handles.sldWinWidth,'Value');
tmpC = get(handles.sldWinCenter,'Value');
if (tmpC > maxx)
    set(handles.sldWinCenter,'value',maxx); 
else if (tmpC< minn)
        set(handles.sldWinCenter,'value',minn); 
    end
end
if (tmpW > (maxx-minn))
    set(handles.sldWinWidth,'value',maxx-minn); 
end

imgToShow = visualProcess(oriImg,handles);
tglBtnSegShowState = get(handles.tglBtnSegShow,'Value');
if curSlice == curSegSlice && tglBtnSegShowState == 1
    thresholdValue = ostu(imgToShow);
    roiRegion = imgToShow(curSliceRoi(2):curSliceRoi(1),curSliceRoi(3):curSliceRoi(4));
    roiRegion(roiRegion > thresholdValue) = 256;
    imgToShow(curSliceRoi(2):curSliceRoi(1),curSliceRoi(3):curSliceRoi(4)) = roiRegion;
    imgToShow(:,:,1) = imgToShow(:,:,1);
    imgToShow(:,:,2) = imgToShow(:,:,1);
    imgToShow(:,:,3) = imgToShow(:,:,1);
    imgToShow(curSliceRoi(2):curSliceRoi(1),curSliceRoi(3):curSliceRoi(4),2) = 0;
    imgToShow(curSliceRoi(2):curSliceRoi(1),curSliceRoi(3):curSliceRoi(4),3) = 0;
end
imshow(imgToShow,'parent',handles.axesImg);

% pos = get(handles.axesImg,'position');
tpos(1) = 256; tpos(2) = 1; tpos(3) = 1; tpos(4) = 256;
tglDrawState = get(handles.tglBtnDrawRoi,'Value');
if flagGoodQual == 1 && handles.uidata.isDrawingRoi == 0
    drawBoxes(handles.axesImg,tpos,[1 1 0]);
end
if sum(curRoi)>0 && handles.uidata.isDrawingRoi == 0
    drawBoxes(handles.axesImg,curRoi,[0 1 0]);
    if curRoi(1) >= 0 && curRoi(2) > 0 && curRoi(3) > 0 && curRoi(4) > 0 && abs(curRoi(1) - curRoi(2))>0....
        && abs(curRoi(3) - curRoi(4)) > 0
        axes(handles.axesStat);
        roiRegion = uint16(oriImg(curRoi(2):curRoi(1),curRoi(3):curRoi(4)));
        maxValue = max(max(roiRegion));
        minValue = min(min(roiRegion));
        [counts x] = imhist(roiRegion,65536);
        imhist(roiRegion,65536);
        set(gca,'xlim',[minValue maxValue],'ylim' ,[0 max(counts)]);
    else
        axes(handles.axesStat);
        plot([1 1],[0 0]);
    end
end
set(handles.ckbGoodQual,'Value',flagGoodQual);

function drawBoxes(h,pos,color)
axes(h)
hold on
plot(h,[pos(3) pos(4) pos(4) pos(3 ) pos(3)],[pos(1) pos(1) pos(2) pos(2) pos(1)],'color',color,'linestyle','-','linewidth',3);
hold off

function edtDispNumTime_Callback(hObject, eventdata, handles)
% hObject    handle to edtDispNumTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtDispNumTime as text
%        str2double(get(hObject,'String')) returns contents of edtDispNumTime as a double


% --- Executes during object creation, after setting all properties.
function edtDispNumTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtDispNumTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edtDispNumLoc_Callback(hObject, eventdata, handles)
% hObject    handle to edtDispNumLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtDispNumLoc as text
%        str2double(get(hObject,'String')) returns contents of edtDispNumLoc as a double


% --- Executes during object creation, after setting all properties.
function edtDispNumLoc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtDispNumLoc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ckbGoodQual.
function ckbGoodQual_Callback(hObject, eventdata, handles)
% hObject    handle to ckbGoodQual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ckbGoodQual
%todo:1. get curSlice and curSeries
%todo:2. update the handles.uidata.flagGoodQual
%todo:3. if qoodquality ,draw yellow box outside the axesImg

curSlice = handles.uidata.curSlice;
curSeries = handles.uidata.curSeries;

fgq = get(hObject,'Value');
handles.uidata.flagGoodQual(curSeries,curSlice) = fgq;

if fgq == 1
%     pos = get(handles.axesImg,'Position');
    ymin = 1
    ymax = 256;
    xmin = 1;
    xmax = 256;
    drawBoxes(handles.axesImg,[ymax ymin xmin xmax],[1 1 0]);
else
    loadDcmImages(handles);
end
guidata(hObject,handles);

% --- Executes on slider movement.
function sldWinWidth_Callback(hObject, eventdata, handles)
% hObject    handle to sldWinWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%todo: retrieve the window width,update the uidata.contrast ,reload the current Img. 
handles.uidata.contrast = get(handles.sldWinWidth,'value');
handles = loadDcmImages(handles);
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function sldWinWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldWinWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sldWinCenter_Callback(hObject, eventdata, handles)
% hObject    handle to sldWinCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%todo: retrieve the window center,update uidata.luminosity(winCenter) , reload the curImg

handles.uidata.luminosity = get(handles.sldWinCenter,'value');
handles = loadDcmImages(handles);
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function sldWinCenter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldWinCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sldSlice_Callback(hObject, eventdata, handles)
% hObject    handle to sldSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider
%todo:1. get the value of slider
%todo:2. load the image if curSlice changed
%todo:3. update the edtDiapNumLoc and lbFileList and reset tglBtnDrawRoi

minValue = get(handles.sldSlice,'min');
maxValue = get(handles.sldSlice,'max');
oldSlice = handles.uidata.curSlice;
handles.uidata.curSlice = minValue + maxValue - floor(get(handles.sldSlice,'Value'));

if handles.uidata.curSlice < 1 || handles.uidata.curSlice > handles.uidata.locationNumber
    return;
end
if oldSlice == handles.uidata.curSlice
    return;
end
handles = loadDcmImages(handles);

set(handles.edtDispNumLoc,'String',num2str(handles.uidata.curSlice));
set(handles.lbFileList,'value',doubleInd2singleInd(handles.uidata.curSlice,handles.uidata.curSeries,handles));
set(handles.tglBtnDrawRoi,'Value',0);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sldSlice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldSlice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sldSeries_Callback(hObject, eventdata, handles)
% hObject    handle to sldSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%todo:1. get the current value of the slider
%todo:2. reload the iamge if series changed
%todo:3. update the text control edtDispNumTime and listbox control
%        lbFileList,respectively. reset tglBtnDrawRoi
oldSeries = handles.uidata.curSeries;
handles.uidata.curSeries = ceil(get(handles.sldSeries,'Value'));

if handles.uidata.curSeries < 1 || handles.uidata.curSeries > handles.uidata.timeNumber
    return;
end
if oldSeries == handles.uidata.curSeries
    return;
end
handles = loadDcmImages(handles);

set(handles.edtDispNumTime,'String',num2str(handles.uidata.curSeries));
set(handles.lbFileList,'Value',doubleInd2singleInd(handles.uidata.curSlice,handles.uidata.curSeries,handles));
set(handles.tglBtnDrawRoi,'Value',0);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sldSeries_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldSeries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btnTest.
function btnTest_Callback(hObject, eventdata, handles)
% hObject    handle to btnTest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%todo: just for some tests.
set(handles.edtDispNumTime,'string','2');


% --- Executes on button press in tglBtnZoomReset.
function tglBtnZoomReset_Callback(hObject, eventdata, handles)
% hObject    handle to tglBtnZoomReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tglBtnZoomReset

% --- Executes on button press in tglBtnZoom.
function tglBtnZoom_Callback(hObject, eventdata, handles)
% hObject    handle to tglBtnZoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tglBtnZoom
%todo: set the zoom state to the value of hObjet.
tglbtnState = get(hObject,'value');
if tglbtnState == 1
    zoom on;
else
    zoom off;
end

% --- Executes on button press in tglBtnSegShow.
function tglBtnSegShow_Callback(hObject, eventdata, handles)
% hObject    handle to tglBtnSegShow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%todo:1. if the state changes, reload the current image

loadDcmImages(handles);
guidata(hObject,handles);

function [slice series] = singleInd2doubleInd(singleIndex,handles)
%todo:1. get the whole location
%todo:2. compute the current series and current slice

wholeSlice = handles.uidata.locationNumber;

slice = mod(singleIndex,wholeSlice);
if slice == 0
    slice = wholeSlice;
end
series = ceil(singleIndex / wholeSlice);

function singleIndex = doubleInd2singleInd(slice,series,handles)
%todo: get the whole slice,compute the singleIndex

wholeSlice = handles.uidata.locationNumber;
singleIndex = wholeSlice * (series - 1) + slice;


% --- Executes on button press in tglBtnDataCursor.
function tglBtnDataCursor_Callback(hObject, eventdata, handles)
% hObject    handle to tglBtnDataCursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tglBtnDataCursor
%todo:1. on or off the datacursormode according to the tgbtn state.

tglbtnState = get(handles.tglBtnDataCursor,'value');
if tglbtnState == 0
    datacursormode off;
    return;
else
    datacursormode on;
end


% --- Executes on button press in btnStatInfo.
function btnStatInfo_Callback(hObject, eventdata, handles)
% hObject    handle to btnStatInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

curSeries = handles.uidata.curSeries;
curSlice = handles.uidata.curSlice;
curIndex = doubleInd2singleInd(curSlice,curSeries,handles);
curRoi = floor(handles.uidata.allRoi(curIndex,:));
if ~(curRoi(1) >= 0 && curRoi(2) > 0 && curRoi(3) > 0 && curRoi(4) > 0 && abs(curRoi(1) - curRoi(2))>0....
    && abs(curRoi(3) - curRoi(4)) > 0)
    return;
end

dcmInfo = handles.uidata.dcmInfo;
locNum = handles.uidata.locationNumber;
n = length(dcmInfo);
j = 1;

refImg = double(dicomread(dcmInfo{curIndex}));% 需正确性验证
refImgLocal = refImg(curRoi(2):curRoi(1),curRoi(3):curRoi(4));
refImgLocal = refImgLocal(:);
refImg = refImg(:);
for i = curSlice:locNum:n
    img = double(dicomread(dcmInfo{i}));
    imgLocal = img(curRoi(2):curRoi(1),curRoi(3):curRoi(4));
    imgLocal = imgLocal(:);
    img = img(:);
    
    a1 =0.01;a2 = 0.01;a3 =0.01;
    a = 0.1; b = 0.2; c = 0.7;
    u1 = mean(refImgLocal);u2 = mean(imgLocal);
    c1 = std(refImgLocal);c2 = std(imgLocal);
    c12_tmp = cov(refImgLocal,imgLocal);
    c12 = c12_tmp(2);
    l = (2*u1*u2+a1)/(u1*u1+u2*u2+a1);
    c = (2*c1*c2+a2)/(c1*c1+c2*c2+a2);
    s = (2*c12+a3)/(c1*c2+a3);
    ssimLocal(j) = l^a + c^b + s^c;
    
    t3 = corrcoef(refImgLocal,imgLocal);
    corrLocal(j) = t3(2);
    contr(j) = cmptContr(img);
%     arrEntropy(j) = entropy(double(img));
    j = j + 1;
end

ssimMax = find(diff(sign(diff(ssimLocal)))<0) + 1;
corrMax = find(diff(sign(diff(corrLocal)))<0) + 1;

contr = contr/max(contr); %normalization
ssimLocal = ssimLocal/max(ssimLocal);%normalizationi
startInd = find(contr == max(contr));%when contrast agent starts work,record the startInd 
endInd = length(contr);
polyfun = polyfit(startInd:endInd,contr(startInd:end),3);%fit the curve of contrast when the contrast agent(CA) is injected
polyfunder = polyder(polyfun);%derivative of the curve of contrast
polyfunderval = polyval(polyfunder,startInd:endInd);
polyfunderval = abs(polyfunderval);
midInd = find(polyfunderval == min(polyfunderval));%look for the point whose derivate is nearst to 0 (对比度曲线平滑处)
midInd = midInd + round(length(contr)/20);%determinate the point when the effect of CA is over.

sMax = ssimMax(find(ssimMax>=startInd));
sMax = sMax(find(sMax<=midInd));%during the period when CA is in effect,determine the good images

%after the effect of CA,select a small number images from the rest with the
%ratio of 1/5
tmpInd = ssimMax(find(ssimMax > midInd));
tmpval = sort(ssimLocal(tmpInd),'descend');
tmpval = tmpval(1:floor(length(tmpval)/5));
n = length(tmpval);
for i = 1:n
    sMax = [sMax find(ssimLocal ==tmpval(i))];
end

sMax = sort(sMax);
ssimIndex = doubleInd2singleInd(curSlice,sMax,handles);
indices = HighQualitySelection(dcmInfo{ssimIndex},sMax,length(dcmInfo)/locNum);

a=10;
for i = 1:length(sMax)
    img = double(dicomread(dcmInfo{ssimIndex(i)}));
    entr(i) = entropy(img);
    bw1 = edge(img,'sobel');
    bw2 = edge(img,'canny');
    bw3 = edge(img,'log');
    figure,subplot(2,2,1),imshow(img,[]),subplot(2,2,2),imshow(bw1),subplot(2,2,3),imshow(bw2),subplot(2,2,4),imshow(bw3);
end
figure;plot(entr,'r-o');
for i = 1:length(sMax)
    text(i,entr(i),num2str(i));
end
%尝试对参考图像分10级进行模糊，比较其他图像与这10级中哪一级相似，也就确定了该图像的模糊程度
% theta = 0;
% imgRef =  double(dicomread(dcmInfo{955}));
% for i = 1:10
%     %filt = fspecial('motion',i*1.9,theta);
%     filt = fspecial('gaussian',[i i],i*0.2);
%     imgBlurry(:,:,i) = imfilter(imgRef,filt,'circular');
% end
% num = length(ssimIndex);
% for p = 1:num
%     img = double(dicomread(dcmInfo{ssimIndex(p)}));
%     for i = 1:10
%         tmp = corrcoef(imgBlurry(:,:,i),img);
%         similarity(i) = tmp(2);
%     end
%     tmp = find(similarity == max(similarity));
%     blurDegree(p) = tmp(1);
% end
% figure,plot(blurDegree,'-*'),hold on;
% for i = 1:num
%     text(i,blurDegree(i),num2str(i));
% end
% for i = 1:10
%     figure,imshow(imgBlurry(:,:,i),[]);
% end


    

% --- Executes on mouse press over axes background.
function axesImg_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%todo:1. if it is in drawing state, save the beginning point in curPt1

state = get(handles.tglBtnDrawRoi,'Value');
if state == 0
    return;
end
handles.uidata.isDrawingRoi = 1;
pos = get(handles.axesImg,'CurrentPoint');
handles.uidata.curPt1 = pos(1,1:2);
handles.uidata.curPt2 = pos(1,1:2);
guidata(hObject,handles);
%loadDcmImages(handles);

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%todo:1. if it is in draw ROI state, record the current point in pt2
%todo:2. retrieve the Pt1 , drawBoxes{[ymax ymin xmin xmax]} , update uidata.curPt2

state = get(handles.tglBtnDrawRoi,'Value');
if handles.uidata.isDrawingRoi == 0 || state == 0
    return;
end
loadDcmImages(handles);
pt2 = get(handles.axesImg,'CurrentPoint');
pt2 = pt2(1,1:2);
pt2(pt2>256) = 256;

pt1 = handles.uidata.curPt1;
drawBoxes(handles.axesImg,[pt2(2) pt1(2) pt1(1) pt2(1)],[0 1 0]);
handles.uidata.curPt2 = pt2;
guidata(hObject,handles);

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%todo:1. get the double index and compute the single index.
%todo:2. update roi of curImg with the two points,clear curPts,reset the
%        isDrawing state to 0, guidata, reload the images for outbox

state = get(handles.tglBtnDrawRoi,'Value');
if state ==0 || handles.uidata.isDrawingRoi == 0
    return;
end
slice = handles.uidata.curSlice;
series = handles.uidata.curSeries;
dcmInd = doubleInd2singleInd(slice,series,handles);
ymaxmin = sort([handles.uidata.curPt2(2) handles.uidata.curPt1(2)],'descend');
xminmax = sort([handles.uidata.curPt1(1) handles.uidata.curPt2(1)],'ascend');
handles.uidata.allRoi(dcmInd,:) = [ymaxmin(1) ymaxmin(2) xminmax(1) xminmax(2)];
% handles.uidata.allRoi(dcmInd,:) = [handles.uidata.curPt2(2) handles.uidata.curPt1(2)...
%                 handles.uidata.curPt1(1) handles.uidata.curPt2(1)];
handles.uidata.curPt1 = [];
handles.uidata.curPt2 = [];
handles.uidata.isDrawingRoi = 0;
guidata(hObject,handles);
loadDcmImages(handles);

% --- Executes on button press in tglBtnDrawRoi.
function tglBtnDrawRoi_Callback(hObject, eventdata, handles)
% hObject    handle to tglBtnDrawRoi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tglBtnDrawRoi


% --- Executes on button press in btnSelectOptimum.
function btnSelectOptimum_Callback(hObject, eventdata, handles)
% hObject    handle to btnSelectOptimum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%todo:1. select the best 10 images in curSlice location
%todo:2. display interface for hightqualityselection



% --- Executes on button press in btnReset.
function btnReset_Callback(hObject, eventdata, handles)
% hObject    handle to btnReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% zoom reset;
% zoom off;
%set(handles.tglBtnZoom,'Value',0);
%loadDcmImages(handles);
