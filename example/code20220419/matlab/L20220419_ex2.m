%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习使用函数：imnoise
% 调用 imnoise 给图像加上高斯噪声、椒盐噪声
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clc;clear;

% 测试图 pattern.bmp 仅有三个灰度值：30,150,230
% 灰度最小值不用0，最大值不用255，
% 可避免叠加正负值噪声后超出[0 255]范围，
% 也便于测试椒盐噪声
im = mat2gray(imread('..\\data\\pattern.bmp'),[0 255]);% 注意此处灰度值区间
% im 有3个灰度数值：0.1176，0.5882，0.9020

%%%%%%%%%%%%%%%%%%
% 在测试图上加噪声
% imnoise expects pixel values of data type double and single to be in the range [0, 1]. 
% You can use the rescale function to adjust pixel values to the expected range. 
% If your image is type double or single with values outside the range [0,1], 
% then imnoise clips input pixel values to the range [0, 1] before adding noise.

% 加椒盐噪声 
d = 0.2;
im_sp = imnoise(im,'salt & pepper',d); % adds salt and pepper noise, where d is the noise density. This affects approximately d*numel(I) pixels.

% 显示图像
figure;
subplot(221);imshow(im);subplot(223);bar(imhist(im),'BarWidth',3);
subplot(222);imshow(im_sp,[]);subplot(224);bar(imhist(im_sp),'BarWidth',3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 加高斯噪声，均值 = m ，方差 = var
m = 0;
v = 0.001; % var = std^2
im_g = imnoise(im,'gaussian',m,v); % adds Gaussian white noise with mean m and variance var.
figure;subplot(121);imshow(im_g,[]);subplot(122);bar(imhist(im_g),'BarWidth',3);

