function singleIndex = doubleInd2singleInd(slice,series,handles)
%todo: get the whole slice,compute the singleIndex

wholeSlice = handles.uidata.locationNumber;
singleIndex = wholeSlice * (series - 1) + slice;