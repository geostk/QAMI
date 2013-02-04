function [imgToShow] = visualProcess(imgOri,handles)
%todo:1. get window width and window center
%todo:2. map the imgOri image to imgToShow

tmpW =  get(handles.sldWinWidth,'Value');
tmpC = get(handles.sldWinCenter,'Value');
Gm = 256.0;

imgToShow = uint8(Gm/tmpW*(imgOri + tmpW / 2.0 - tmpC));
imgToShow(imgOri< tmpC - tmpW / 2.0) = uint8(0);
imgToShow(imgOri>tmpC + tmpW / 2.0) = uint8(Gm);