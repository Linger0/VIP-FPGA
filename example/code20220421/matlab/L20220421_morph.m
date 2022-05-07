%%%%%%%%%%%%%%%%%%%%%
% 查看Matlab文档，学习如下函数：
% strel
% imdilate | imerode
% imclose | imopen
% imtophat | imbothat
% 
% 例如：在命令行窗口输入：
% doc strel
%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all;

im=mat2gray(imread('..\\data\\rice.png'),[0 255]);
figure;imshow(im);title('原图像');
figure;bar(imhist(im));title('原图像直方图');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Otsu全局阈值分割
[Th1,EM1] = graythresh(im);
mymask1 = imbinarize(im,Th1);
figure;imshow(mymask1);title('Otsu阈值分割');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% 顶帽滤波
se = strel('disk',11);
se.Neighborhood % 21×21 logical 数组
im_tophat=imtophat(im,se);
figure;imshow(im_tophat);title('顶帽滤波');
figure;bar(imhist(im_tophat));title('顶帽滤波直方图');
[Th2,EM2] = graythresh(im_tophat);
mymask2 = imbinarize(im_tophat,Th2);
figure;imshow(mymask2);title('顶帽滤波+Otsu阈值分割');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
