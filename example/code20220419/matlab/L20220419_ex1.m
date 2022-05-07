%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习如何在测试图上叠加随机噪声
% 学习使用函数：rand，randn
% 提高：使用均匀随机数生成具有规定分布的随机数
clc;clear;close all;

% 测试图 pattern.bmp 仅有三个灰度值：30,150,230
% 灰度最小值不用0，最大值不用255，
% 可避免叠加正负值噪声后超出[0 255]范围，
% 也便于测试椒盐噪声
I = imread('..\\data\\pattern.bmp');% 注意此处灰度值区间
figure(1);hold on;
subplot(231);imshow(I);title('测试图','FontSize',14);
subplot(234);bar(imhist(I));title('测试图直方图','FontSize',14);

im = mat2gray(I,[0 255]);% 注意此处灰度值区间,写成 mat2gray(I)结果怎样？
% im有3个数值：0.1176，0.5882，0.9020
% 为简化分析，叠加的噪声值大小在[-0.1 0.1]区间内
figure(1);hold on;
subplot(231);imshow(im);title('测试图','FontSize',14);
subplot(234);bar(imhist(im));title('测试图直方图','FontSize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%产生高斯噪声 noiseg，均值为m，方差为v
m = 0;
v = 0.001;
noise_n = randn(size(im,1),size(im,2)); % 得到由标准正态分布的随机数组成的矩阵
noiseg = sqrt(v)*noise_n + m; % 得到规定均值和方差正态分布的随机数
% 显示噪声图像和噪声图像的直方图
subplot(232);imshow(noiseg,[]);title('高斯噪声图像','FontSize',14);
subplot(235);histogram(noiseg(:),64);title('高斯噪声直方图','FontSize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%在测试图上加高斯噪声
fg = im + noiseg;
% 显示图像
subplot(233);imshow(fg);title('加高斯噪声的测试图','FontSize',14);
subplot(236);bar(imhist(fg));title('噪声测试图直方图','FontSize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 加均匀噪声 noiseu ，在 (-0.05,0.05) 区间均匀分布
a = -0.05;b = 0.05;
noise_n = rand(size(im,1),size(im,2));% 得到在区间(0,1)内均匀分布的随机数矩阵
noiseu = (a+(b-a)*noise_n);
fu = im + noiseu;
% 显示图像
figure;
subplot(221);imshow(noiseu,[]);title('均匀噪声图像');
subplot(222);histogram(noiseu(:),64);title('均匀噪声直方图');
subplot(223);imshow(fu);title('加均匀噪声的测试图');
subplot(224);bar(imhist(fu));title('噪声测试图直方图');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 加瑞利噪声
% 使用均匀随机数生成具有规定分布的随机数
% 参考直方图匹配的思路
a = -0.04;
b = 0.0032;
noise_n = rand(size(im,1),size(im,2));
noiser = (a + sqrt(-b*log(1-noise_n))); % 瑞利噪声CDF的反函数
fr = im + noiser;
figure;
subplot(221);imshow(noiser,[]);title('瑞利噪声图像');
subplot(222);histogram(noiser(:),64);title('瑞利噪声直方图');
subplot(223);imshow(fr);title('加瑞利噪声的测试图');
subplot(224);bar(imhist(fr));title('噪声测试图直方图');






