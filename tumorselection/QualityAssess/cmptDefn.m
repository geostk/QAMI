function def = cmptDefn(I)
%CMPTDEFN Summary of this function goes here
%   Detailed explanation goes here
%   ARGS:
%   I:the input image
%   def:definition of image I
I = double(I);
[GX GY] = gradient(I);
G = sqrt(GX.*GX+GY.*GY);
def = sum(sum(G));