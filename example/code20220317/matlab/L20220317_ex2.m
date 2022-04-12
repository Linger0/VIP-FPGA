clc;clear;close all;
%% 读入一幅彩色图像
I_rgb = imread('..//data//lena.jpg');
%% question
% 改变通道值的顺序结果怎样？
I = I_rgb;
I(:,:,1) =I_rgb(:,:,3);
I(:,:,3) =I_rgb(:,:,1);
figure;imshow(I);