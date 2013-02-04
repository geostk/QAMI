function [ contrast ] = cmptContr( I )
%CMPTCONTR Summary of this function goes here
%   Detailed explanation goes here
%   ARGS:
%   I:the input image
%   contrast:contrast ration
I = double(I);
mse = mean2((I - mean2(I)).*(I - mean2(I)));
contrast = mse;
end