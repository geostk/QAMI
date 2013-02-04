function [ peaks valleys ] = lookForExtreme( arr )
%LOOKFOREXTREME Summary of this function goes here
%   Detailed explanation goes here
%note:...
%todo:1. detect each value arr(i),if it is a extreme value,record it
%todo:2. remove the early date value, for the cause of zao ying ji.
%todo:3. peak and valley is one by one,put the near value in correspond
%        group.

peaks = [];
valleys = [];
arr = arr(:);
n = size(arr,1);
if n<3
    return;
end
indPeak = 1;
indValley = 1;
for i = 2 : n-1
    if arr(i) == max(arr(i-1:i+1))
        peaks(indPeak) = i;
        indPeak = indPeak + 1;
    end
    if arr(i) == min(arr(i-1:i+1))
        valleys(indValley) = i;
        indValley = indValley + 1;
    end
end

if peaks(1) < valleys(1)
    peaks(1) = [];
else
    valleys(1) = [];
end
peaks(peaks<=10) = [];
valleys(valleys<=10) = [];
% if abs(length(peaks) - length(valleys)) > 1
%     return;
% end
% if(peaks(1)<valleys(1))
%     for i = 1:length(peaks)
%         for j = peaks(i)+1:valleys(i)-1
%             d = arr(peaks(i)) - arr(valleys(i));
%             d1 = arr(peaks(i)) - arr(j);
%             d2 = arr(j) - arr(valleys(i));
%             if d1 < 0.1*d
%                 peaks = [peaks(1:i) j peaks(i:end)];
%             end
%             if d2 < 0.1*d
%                 valleys = []
%                 
% else
%     m = length(valleys);
% end
% for i = 1:m
%     
