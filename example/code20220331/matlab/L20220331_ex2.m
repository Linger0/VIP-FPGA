%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习使用如下函数：
% imfilter, padarray, filter2, conv2
% mat2gray，rescale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;close all;clear;

%%%%%%%%%%
%     相关 与 卷积 比较     %
%%%%%%%%%%
% 创建一幅图像 img
img = zeros(9);
img(3:7,3:7) = ones(5)*255;
img=uint8(img)

% 创建滤波器 f_sobel
f_sobel=[1 2 1;0 0 0 ;-1 -2 -1]

% 相关 与 卷积 对比
img_imfilter_corr = imfilter(img,f_sobel,'corr')
img_imfilter_conv= imfilter(img,f_sobel,'conv')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

