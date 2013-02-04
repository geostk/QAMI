function [ txt ] = myDatacursorTextFcn( empt,event_obj )
%MYDATACURSORTEXTFCN Summary of this function goes here
%   Detailed explanation goes here
%todo:1. get the cursor position and the rgb value
%todo:2. customize display text

pos = get(event_obj,'Position');
%rgbValue = 

txt = {['Time: ',num2str(pos(1))],...
['Amplitude: ',num2str(pos(2))]};

end
