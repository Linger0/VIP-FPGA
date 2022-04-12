clc;clear;close all;

%% 1. 读入一幅灰度图
I_gry = imread('..//data//lenna_gray.jpg');
figure;imshow(I_gry);

%% 2.
% 查看工作区的数据组成: 2维数组 - m*n
% 空间离散 m*n
% 亮度离散 uint8
% 注意：数值运算时不能用整型数据类型

%% 3.读入一幅彩色图
I_rgb = imread('..//data//lena.jpg');
figure;imshow(I_rgb);

%% 4.
% 查看工作区的数据组成: 3维数组 - m*n*3
% 3个颜色通道
% 各通道代表什么颜色？
I = I_rgb;
I(:,:,1) =255;
I(:,:,2) =0;
I(:,:,3) =0;
figure;imshow(I);