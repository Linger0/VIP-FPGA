%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习使用如下函数：
% imfilter, padarray, filter2, conv2
% mat2gray，rescale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;close all;clear;

%%%%%%%%%%%%
%  空间滤波 示例    %
%%%%%%%%%%%%
% 创建图像
A=zeros(512,512);
A(1:256,257:512)=255;
A(257:512,1:256)=255;
figure;hold on;imshow(uint8(A));title('原图');
% 设计滤波器
h=ones(21,21)/(21*21);
% 线性滤波
B= imfilter(A,h); % the center of the kernel is floor((size(h) + 1)/2).
% 显示结果（注意imshow参数的数据类型）
figure;hold on;imshow(B);title('滤波后');
figure;hold on;imshow(uint8(B));title('滤波后');
figure;hold on;imshow(rescale(B));title('滤波后');% scales the entries of an array to the interval [0,1]. 
figure;hold on;imshow(mat2gray(B));title('滤波后');% mat2gray: returned as a numeric matrix with values in the range [0, 1].Data Types: double
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 采用不同边界填充方法
close all
B1= imfilter(A,h,0); % 使用p值填充（p=0） 
B2= imfilter(A,h,'replicate'); % 复制图像边界像素的值
B3= imfilter(A,h,'symmetric'); % 镜像图像边界像素的值
B4= imfilter(A,h,'circular'); % 周期扩展

% 显示结果
figure;
subplot(231);imshow(mat2gray(A));title('原图');
subplot(232);imshow(mat2gray(B1));title('填充0');
subplot(233);imshow(mat2gray(B2));title('复制边界');
subplot(235);imshow(mat2gray(B3));title('镜像扩展');
subplot(236);imshow(mat2gray(B4));title('周期扩展');

% B0与B1是否相同？
% B2与B3是否相同？
% B1与B4是否相同？

% 填充0 与 周期扩展 结果的差异
figure;hold on;
plot(B1(128,1:12),'r*-');
plot(B4(128,1:12),'b*-');
legend('填充0','周期扩展');

Sub_1_4 = B1-B4;
figure;imshow(rescale((Sub_1_4)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

