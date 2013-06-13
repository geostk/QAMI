function score = iqa(im,h)
%mqa Summary of this function goes here
%   Detailed explanation goes here
%     score: quantification of image quality(0~1)

    im = im2double(im);
    imblurred = imfilter(im,h);
    bw = edge(im,'canny');
    [m,n] = size(im);
    
    s = 0;
    for i = 2:m-1
        for j = 2:n-1
            if bw(i,j) == 1
                matIm = im(i-1:i+1,j-1:j+1);
                matImblurred = imblurred(i-1:i+1,j-1:j+1);
                similarity = corr2(matIm,matImblurred);
                s = s + similarity;
            end
        end
    end
    score = s/(sum(bw(:))+0.0001);


score = 1 - score;
score = (score - 0.02) / (0.08-0.02);