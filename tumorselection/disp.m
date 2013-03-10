function [ output_args ] = disp( arr )
%DISP Summary of this function goes here
%   Detailed explanation goes here

%todo:1. plot the array who is 1D
%todo:2. denote the numbers on the nodes

n = length(arr);
figure,plot(arr);

for i = 1:n
    text(i,arr(i),num2str(i));
end
