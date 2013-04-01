function dSNR = snr(ImageA,ImageB)
% ����snr(�����)
% ImageA:��һ��ͼ��
% ImageB:�ڶ���ͼ��
% dSNR:��������ͼ�񣬼��������

if (size(ImageA,1) ~= size(ImageB,1)) or (size(ImageA,2) ~= size(ImageB,2))
    error('ImageA <> ImageB');
    dSNR = 0;
    return ;
end
ImageA=double(ImageA);
ImageB=double(ImageB);
M = size(ImageA,1);
N = size(ImageA,2);
    
d1 = 0 ;
d2 = 0;
for i = 1:M
    for j = 1:N
        d1 = d1 + (ImageA(i,j) - ImageB(i,j)).^2 ;
        d2 = d2 + ImageA(i,j).^2;
    end
end

dSNR = 10*log10((d2/d1));

return
