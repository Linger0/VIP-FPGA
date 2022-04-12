%%%%%%%%%%%%%%%%%%%%%%%
% fftshift 
%%%%%%%%%%%%%%%%%%%%%%%
clc;close all;clear;
imA=imread('..\\data\\Fig0427.tif');
figure;imshow(imA);title('原图像');

% Y = fftshift(X) 通过将零频分量移动到数组中心，重新排列傅里叶变换 X。
% 如果 X 是向量，则 fftshift 会将 X 的左右两半部分进行交换。
% 如果 X 是矩阵，则 fftshift 会将 X 的第一象限与第三象限交换，将第二象限与第四象限交换。
% 如果 X 是多维数组，则 fftshift 会沿每个维度交换 X 的半空间。
imAshift=fftshift(imA);
figure;imshow(imAshift);title('fftshift');

%%%%%%%%%%%%%%%%%%%%%%%
