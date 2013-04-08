function MuInf = mi(image1,image2,method)
%   MI    ����Ϣ��ȣ�Mutual Information�����㺯��
%   method����ѡ����㻥��Ϣ���ǹ�һ������Ϣ��Normalized Mutual Information��
Joint_h = Jointh_My(image1,image2);
[r,c] = size(Joint_h);
N_Jh = Joint_h./(r*c);
Marg_A = sum(N_Jh);
Marg_B = sum(N_Jh,2);
H_A = 0;H_B = 0;

%% �غ���
for k = 1:r
    if Marg_A(k) ~= 0
        H_A = H_A+(-Marg_A(k)*log2(Marg_A(k)));
    end
end
for k = 1:c
    if Marg_B(k) ~= 0
        H_B = H_B+(-Marg_B(k)*log2(Marg_B(k)));
    end
end
H_AB = sum(sum(-N_Jh.*log2(N_Jh+(N_Jh == 0))));
%% ���
if strmatch(method,'����Ϣ')
    MuInf = H_A+H_B-H_AB;
else
    MuInf = (H_A+H_B)/H_AB;
end



function h = Jointh_My(image1,image2)
%   JOINTH_MY    ͳ��ͼ��image1��image2������ֱ��ͼ
image1 = uint16(image1);
image2 = uint16(image2);
[rows,cols] = size(image1);
maxValue1 = max(image1(:));
maxValue2 = max(image2(:));
maxValue = max([maxValue1 maxValue2]);
h = zeros(maxValue+1,maxValue+1);
for k = 1:rows
    for l = 1:cols
        h(image1(k,l)+1,image2(k,l)+1) = h(image1(k,l)+1,image2(k,l)+1)+1; % ��������ֱ��ͼ
    end
end