%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ѧϰʹ�����º�����
% imfilter, padarray, filter2, conv2
% mat2gray��rescale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;close all;clear;

%%%%%%%%%%
%     ��� �� ��� �Ƚ�     %
%%%%%%%%%%
% ����һ��ͼ�� img
img = zeros(9);
img(3:7,3:7) = ones(5)*255;
img=uint8(img)

% �����˲��� f_sobel
f_sobel=[1 2 1;0 0 0 ;-1 -2 -1]

% ��� �� ��� �Ա�
img_imfilter_corr = imfilter(img,f_sobel,'corr')
img_imfilter_conv= imfilter(img,f_sobel,'conv')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

